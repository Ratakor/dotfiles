# User Shell
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules)
    mkIf
    mkBefore
    mkAfter
    mkOrder
    mkMerge
    ;

  ZDOTDIR = config.hm.programs.zsh.dotDir;
in
{
  imports = [
    ./plugins.nix
  ];

  hm.home = mkIf config.hm.programs.zsh.enable {
    # enables shell integrations for zsh from programs
    # I think it's enabled by default tho
    shell.enableZshIntegration = true;

    packages = with pkgs; [
      zsh-completions
      nix-zsh-completions
    ];

    # Not needed, see programs.zsh.shellInit for why
    file.".zshenv".enable = false;
  };

  hm.programs.zsh = {
    inherit (config.self.programs.shell.zsh) enable;
    dotDir = "${config.hm.xdg.configHome}/zsh";
    enableCompletion = true; # see programs.zsh.completionInit
    enableVteIntegration = true;
    autosuggestion.enable = true; # TODO: bind <C-h> to completion
    autocd = true; # automatically cd into typed directory

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main" # default highlighter (commands, options, args, paths, strings)
        "brackets" # matches brackets and parenthesis
        # "root" # highlight the whole command line if the current user is root
      ];
    };

    # see zshoptions(1)
    setOptions = [
      "RM_STAR_SILENT" # disable double verification with rm -I *
      "IGNORE_EOF" # do not exit on EoF <C-d>
      # "CORRECT"
      # "CORRECT_ALL"
      "noflowcontrol" # disable C-S/C-Q
    ];

    history = {
      # stop cluttering my home
      path = "${config.hm.xdg.stateHome}/zsh/history";

      # share command history between zsh sessions
      share = false;

      # append to the history file instead of overwriting it
      append = true;

      # save timestamp into the history file
      extended = false;

      # avoid duplicates
      save = 100000; # SAVEHIST
      size = 150000; # HISTSIZE
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreAllDups = false;
      ignoreSpace = true; # do not log commands that starts with a space
      ignorePatterns = [ ];
    };

    # not needed with zoxide
    # dirHashes = {};

    envExtra = /* zsh */ ''
      # disable system configuration
      setopt no_global_rcs
    '';

    # compinit flags:
    # -u    Trust all directories from $fpath. (kinda unsafe)
    # -i    Silently ignore insecure directories from $fpath. (useful for distrobox)
    # -C    Skip all checks (compaudit) & use cache as is. (fast)
    completionInit = /* zsh */ ''
      autoload -Uz compinit
      zmodload zsh/complist

      _comp_options+=(globdots) # Include hidden files.
      zcompdump="${ZDOTDIR}"/.zcompdump-"$ZSH_VERSION"-"$(date --iso-8601=date)"
      compinit -i -C -d "$zcompdump"

      # Recompile zcompdump if it exists and is newer than zcompdump.zwc
      # compdumps are marked with the current date in yyyy-mm-dd format
      # which means this is likely to recompile daily
      # which is probably overkill but at least this runs in background
      # https://htr3n.github.io/2018/07/faster-zsh/
      if [[ -s "$zcompdump" && (! -s "$zcompdump".zwc || "$zcompdump" -nt "$zcompdump".zwc) ]]; then
        zcompile "$zcompdump" &!
      fi

      # Load bash completion functions
      # autoload -U +X bashcompinit && bashcompinit

      # Completion configuration
      # idk if still useful since we use fzf-tab plugin
      zstyle ':completion:*' menu select
    '';

    initContent =
      let
        profiling = mkMerge [
          (mkOrder 0 "zmodload zsh/zprof")
          (mkOrder 2000 "zprof")
        ];

        basicSettings = mkBefore /* zsh */ ''
          autoload -U colors && colors # Load colors
          stty stop undef # Disable ctrl-s to freeze terminal.
          KEYTIMEOUT=1 # with vi / helix mode: make switching modes faster
        '';

        promptGitIntegration = mkBefore /* zsh */ ''
          autoload -Uz vcs_info
          precmd_functions+=( vcs_info )
          setopt PROMPT_SUBST
          # who thought two ' was a good idea
          # RPROMPT='${"\${vcs_info_msg_0_}"}'
          RPROMPT=''\'''${vcs_info_msg_0_}'
          zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f'
          zstyle ':vcs_info:*' enable git
        '';

        prompt = /* zsh */ ''
          timer=$(print -P %D{%s%3.})
          function preexec() {
              timer=$(print -P %D{%s%3.})
          }

          function precmd() {
              local now=$(print -P %D{%s%3.})
              [ -z "$timer" ] && timer=$now
              local d_ms=$((now - timer))
              local d_s=$((d_ms / 1000))
              local ms=$((d_ms % 1000))
              local s=$((d_s % 60))
              local m=$(((d_s / 60) % 60))
              local h=$((d_s / 3600))
              unset timer

              if   ((h > 0)); then local elapsed=''${h}h''${m}m''${s}s
              elif ((m > 0)); then local elapsed=''${m}m''${s}.$((ms / 100))s
              elif ((s > 9)); then local elapsed=''${s}.$(printf %02d $((ms / 10)))s
              elif ((s > 0)); then local elapsed=''${s}.$(printf %03d $ms)s
              else local elapsed=''${ms}ms
              fi

              #if [ "$(id -u)" = 0 ]; then
              #    PS1="%B%(?.0.%F{red}%?) %F{magenta}''${elapsed} %F{green}%~ %f%#%b "
              #else
                  PS1="%B%(?.0.%F{red}%?) %F{blue}''${elapsed} %F{green}%~ %f%#%b "
              #fi
          }
        '';

        # none of this code is stupid,
        # it was actually decently hard to make it work properly
        calc = mkAfter /* zsh */ ''
          _calc_accept_line() {
            if [[ $BUFFER =~ '^[ (]*[+-]? *(0[xX]|.)?[[:digit:]]+[^[:alnum:]]' ]]; then
              zle -I
              print -r -- "$(${getExe pkgs.libqalculate} -t -- "$BUFFER")"
              print -rs -- $BUFFER
              BUFFER=
              zle -R
              return 0
            fi
            zle .$WIDGET
          }
          zle -N accept-line _calc_accept_line

          typeset -A ZSH_HIGHLIGHT_REGEXP
          ZSH_HIGHLIGHT_REGEXP+=('\b[0-9]+\b' fg=cyan)
          ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main regexp)
        '';

        # We could use system's comma instead of pkgs.comma because of
        # nix-index-database but it should be alright since we got symlink to
        # cache home.
        commandNotFound = mkAfter /* zsh */ ''
          command_not_found_handler() {
            ${getExe pkgs.comma} "$@"
          }
        '';

        funnyStuffIMeanKindaLikeYeaIdkManItUsedToBeCalledFunnyStuffBefore = mkAfter /* zsh */ ''
          [ -f "${config.age.secrets.aliases.path}" ] && source "${config.age.secrets.aliases.path}"

          quand
          #ls
        '';
      in
      mkMerge [
        # profiling
        basicSettings
        # promptGitIntegration
        # prompt
        calc
        commandNotFound
        funnyStuffIMeanKindaLikeYeaIdkManItUsedToBeCalledFunnyStuffBefore
      ];
  };
}
