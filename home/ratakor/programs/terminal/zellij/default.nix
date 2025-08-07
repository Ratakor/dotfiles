# terminal multiplexer & session manager
{
  config,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    # package = # TODO: patch for zsh completions

    # attachExistingSession = true;
    enableZshIntegration = false; # auto start zellij on each zsh session
    # exitShellOnExit = true;

    # settings = {
    #   theme = "gruvbox-dark";
    #   show_startup_tips = false;
    #   # pane_frames = false;
    #   # simplified_ui = true;
    #   # default_layout = "compact";

    #   # keybinds = {
    #   #   session._children = [
    #   #   ];
    #   # };
    # };
  };

  # TODO: I don't know if this should be here or in home/ratakor/programs/terminal/shell/zsh/variables.nix
  # home.sessionVariables = {
  #   ZELLIJ_CONFIG_DIR = "${config.xdg.configHome}/zellij";
  #   ZELLIJ_CONFIG_FILE = "${config.xdg.configHome}/zellij/config.kdl";
  # };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
