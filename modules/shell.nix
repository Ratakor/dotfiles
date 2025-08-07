# THIS IS UNUSED BTW
{
  inputs,
  pkgs,
  colors,
  username,
  ...
}: {
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        shell = null; # use default shell instead
        useDefaultShell = true;
      };

      ${username} = {
        shell = null;
        userDefaultShell = true;
      };
    };
  };

  environment = {
    shells = with pkgs; [
      dash
      zsh
    ];

    # binsh = "${pkgs.dash}/bin/dash"
    localBinInPath = true;
    homeBinInPath = false;
    # memoryAllocator.provider = "graphene-hardened";
    enableAllTerminfo = false;
    enableDebugInfo = false; # see wiki to enable debug info per package instead
    extraOutputsToInstall = []; # enable it per package instead like `pkg.dev`

    defaultPackages = with pkgs; [
      gnugrep
      less
      neovim # editor
      yazi # file manager
      zellij # terminal multiplexer
      eza # ls replacement
      bat # cat replacement
      dust # du replacement
      duf # df replacement
      fd # find replacement
    ];

    variables = {
      EDITOR = "nvim";
      # VISUAL = "nvim";
    };

    shellAliases = {
      # shorter names and basic stuff changed
      e = "$EDITOR";
      ":q" = "exit";
      ":Q" = "exit";
      bc = "bc -ql";
      tmp = "cd $(mktemp -d)";
      mount = "mount -o nosuid,nodev,noexec";
      g = "grep -RIn --exclude-dir=.git";
      # z = "zellij --layout welcome";
      # zac = "zellij attach --create";
      # y = "yazi";
      mkae = "make";
      musb = "pmount";
      umusb = "pumount";

      # verbosity and colors
      rm = "rm -vI"; # "trash -v";
      rmdir = "rmdir -v"; # -p
      cp = "cp -riv"; # --reflink=always
      mv = "mv -iv";
      mkdir = "mkdir -pv";
      grep = "grep --color=always -n";
      diff = "diff --color=always";
      ip = "ip --color=always";
      ls = "eza --color=always --group-directories-first --hyperlink";
      sl = "ls";
      ll = "ls -lho --git";
      la = "ls -a";
      laa = "ls -aa";
      l = "ls -lhoa";
      lr = "ls -R";
      tree = "ls -T";
      cat = "bat --style=numbers,changes --tabs 8 --theme=${colors.theme}";
      du = "dust -r";
      duf = "duf -hide special";
      fd = "fd -HI --color=always";
      less = "less -R";
      # vimdiff = "nvim -d";

      # git
      G = "gitui";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gca = "git commit --all";
      gcv = "git commit --verbose";
      gcm = "git commit --message";
      gam = "git commit --amend";
      gp = "git push --follow-tags"; # --tags
      gpl = "git pull";
      gr = "git restore";
      grs = "git restore --staged";
      gd = "git diff";
      gac = "ga . && gc";
      gacv = "ga . && gcv";
      gcp = "gc && gp";
      gacp = "ga . && gc && gp";
      gacpv = "ga . && gcv && gp";
    };

    # I don't know what this is
    # profiles = [];
    # profileRelativeEnvVars = {};
    # profileRelativeSessionVariables = {};
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    autosuggestions.enable = true;

    # TODO: doesn't work well for root
    # histFile = "\${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history";
    # histSize = 10000;

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main" # default highlighter (commands, options, args, paths, strings)
        "brackets" # matches brackets and parenthesis
        # "root" # highlight the whole command line if the current user is root
      ];
    };

    # this is in /etc/zshenv
    # see environment.shellInit too
    shellInit = ''
      # Change ZDOTDIR to not have a symlink in $HOME
      export ZDOTDIR="$HOME/.local/etc/zsh"
    '';

    # this is when logging into a shell (tty, sudo -i, su)
    # see environment.loginShellInit too
    loginShellInit = ''
    '';

    # TODO: duplicate autocompletion
    # TODO: git RPROMPT should be '${vcs_info_msg_0_}'
    # this is in /etc/zshrc
    # see environment.interactiveShellInit too
    interactiveShellInit = ''
      # Some basic settings
      autoload -U colors && colors # Load colors
      stty stop undef # Disable ctrl-s to freeze terminal.
      KEYTIMEOUT=1 # related to vim mode

      # Basic auto/tab complete
      autoload -U compinit
      zstyle ':completion:*' menu select
      compinit
      _comp_options+=(globdots) # Include hidden files.

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
      RPROMPT='$vcs_info_msg_0_'
      zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f'
      zstyle ':vcs_info:*' enable git
    '';

    # see zshoptions(1)
    setOptions = [
      "HIST_IGNORE_DUPS"
      # "SHARE_HISTORY"
      "HIST_FCNTL_LOCK" # improve history performance
      "AUTOCD" # automatically cd into typed directory.
      "RM_STAR_SILENT" # disable double verification with rm -I *
      "VI" # vim mode
      "IGNORE_EOF" # do not exit on EoF <C-d>
      # "PROMPT_SUBST" # git integration...
      # "CORRECT"
      # "CORRECT_ALL"
    ];

    # see environment.shellAliases
    shellAliases = {};

    promptInit = ''
      timer=$(print -P %D{%s%3.})
      function preexec() {
          timer=$(print -P %D{%s%3.})
          echo -ne "\x1b[6 q" # Use beam shape cursor for each new prompt.
      }

      function precmd() {
          local now=$(($(print -P %D{%s%3.}) - 2))
          [ -z "$timer" ] && timer=$now
          local d_ms=$((now - timer))
          local d_s=$((d_ms / 1000))
          local ms=$((d_ms % 1000))
          local s=$((d_s % 60))
          local m=$(((d_s / 60) % 60))
          local h=$((d_s / 3600))
          unset timer

          if   ((h > 0)); then local elapsed=''${h}h''${m}m''${s}s
          elif ((m > 0)); then local elapsed=''${m}m''${s}.$(($ms / 100))s
          elif ((s > 9)); then local elapsed=''${s}.$(printf %02d $(($ms / 10)))s
          elif ((s > 0)); then local elapsed=''${s}.$(printf %03d $ms)s
          else local elapsed=''${ms}ms
          fi

          if [ "$(id -u)" = 0 ]; then
              PS1="%B%(?.0.%F{red}%?) %F{magenta}''${elapsed} %F{green}%~ %f%#%b "
          else
              PS1="%B%(?.0.%F{red}%?) %F{blue}''${elapsed} %F{green}%~ %f%#%b "
          fi
      }
    '';
  };
}
