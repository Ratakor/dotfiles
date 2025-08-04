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
    dotDir = "${config.xdg.configHome}/zsh-nix";
    # extra...
    # sessionVariables = {};
    # setOptions = [];
    # shellAliases = {};
    # shellGlobalAliases = {};
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
