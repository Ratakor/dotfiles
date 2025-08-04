{
  config,
  pkgs,
  ...
}: {
  home.shell.enableZshIntegration = true;

  home.packages = with pkgs; [
    zsh-completions
    nix-zsh-completions
  ];

  programs.zsh = {
    enable = true;
    # TODO
    # enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh-nix";
    # extra...
    # sessionVariables = {};
    # setOptions = [];
    # shellAliases = {};
    # shellGlobalAliases = {};

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  home.file."${config.xdg.configHome}/zsh" = {
    source = ./zsh;
    recursive = true;
  };
}

# {
#   config,
#   ...
# }: let
#   d = config.xdg.dataHome;
#   c = config.xdg.configHome;
#   cache = config.xdg.cacheHome;
# in {
#   # add environment variables
#   home.sessionVariables = {
#     # clean up ~
#     LESSHISTFILE = cache + "/less/history";
#     LESSKEY = c + "/less/lesskey";
#     WINEPREFIX = d + "/wine";

#     # set default applications
#     EDITOR = "nvim";
#     BROWSER = "firefox";
#     TERMINAL = "alacritty";

#     # enable scrolling in git diff
#     DELTA_PAGER = "less -R";

#     MANPAGER = "sh -c 'col -bx | bat -l man -p'";
#   };

#   home.shellAliases = {
#     e = "nvim"; # TODO: use EDITOR
#     y = "yazi";
#   };
# }
