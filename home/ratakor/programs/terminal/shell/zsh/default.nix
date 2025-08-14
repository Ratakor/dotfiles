{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./aliases.nix
    ./plugins.nix
    ./variables.nix
  ];

  home = {
    # enables shell integrations for zsh from programs
    # I think it's enabled by default tho
    shell.enableZshIntegration = true;

    packages = with pkgs; [
      zsh-completions
      nix-zsh-completions
    ];
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
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
      "VI" # vim mode
      "IGNORE_EOF" # do not exit on EoF <C-d>
      # "PROMPT_SUBST" # used below for prompt with git integration
      # "CORRECT"
      # "CORRECT_ALL"
    ];

    history = {
      # stop cluttering my home
      path = "${config.xdg.stateHome}/zsh/history";

      # share command history between zsh sessions
      share = false;

      # append to the history file instead of overwriting it
      append = true;

      # save timestamp into the history file
      extended = true;

      # avoid duplicates
      save = 100000; # SAVEHIST
      size = 150000; # HISTSIZE
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreAllDups = false;
      ignoreSpace = true; # do not log commands that starts with a space
      ignorePatterns = [];
    };

    # not needed with zoxide
    # dirHashes = {};

    envExtra = ''
      # disable system configuration
      setopt no_global_rcs
    '';

    # TODO: clean that
    profileExtra = ''
      # Automatically start River on tty1 if not already running.
      if [ "$(tty)" = "/dev/tty1" ]  && ! pidof -s river >/dev/null 2>&1; then
          timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
          RIVER_LOG_DIR="${config.xdg.stateHome}/river"
          mkdir -p "$RIVER_LOG_DIR"
          exec dbus-run-session river -log-level warning > "''${RIVER_LOG_DIR}/river-''${timestamp}.log" 2>&1
      fi
    '';

    # TODO: improve that, it's a massive slowdown & it could be more ergonomic
    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' menu select
      compinit
      _comp_options+=(globdots) # Include hidden files.
    '';

    # TODO: clean this mess
    initContent = let
      inherit (lib.modules) mkBefore mkAfter mkOrder mkMerge;

      zshProfiling = mkMerge [
        (mkOrder 0 "zmodload zsh/zprof")
        (mkOrder 2000 "zprof")
      ];

      zshConfigBefore = mkBefore ''
        # disable C-S/C-Q
        setopt noflowcontrol

        # Some basic settings
        autoload -U colors && colors # Load colors
        stty stop undef # Disable ctrl-s to freeze terminal.
        KEYTIMEOUT=1 # with vi mode: make switching modes faster

        # Use vim keys in tab complete menu:
        zmodload zsh/complist
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history
        bindkey -v '^?' backward-delete-char

        # Change cursor shape for different vi modes.
        function zle-keymap-select() {
            case $KEYMAP in
                vicmd)
                echo -ne "\x1b[2 q" ;; # block
            viins|main)
                echo -ne "\x1b[6 q" ;; # beam
            esac
        }
        function zle-line-init() {
            echo -ne "\x1b[6 q"
        }
        zle -N zle-keymap-select
        zle -N zle-line-init

        # git integration
        autoload -Uz vcs_info
        precmd_functions+=( vcs_info )
        setopt PROMPT_SUBST
        # who thought two ' was a good idea
        # RPROMPT='${"\${vcs_info_msg_0_}"}'
        RPROMPT=''\'''${vcs_info_msg_0_}'
        zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f'
        zstyle ':vcs_info:*' enable git
      '';

      zshConfig = ''
        # Prompt
        timer=$(print -P %D{%s%3.})
        function preexec() {
            timer=$(print -P %D{%s%3.})
            echo -ne "\x1b[6 q" # Use beam shape cursor for each new prompt.
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

      zshConfigAfter = mkAfter ''
        #quand
        ls -a
      '';
    in
      mkMerge [
        # zshProfiling
        zshConfigBefore
        zshConfig
        zshConfigAfter
      ];
  };
}
