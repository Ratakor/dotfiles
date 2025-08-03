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
    enableZshIntegration = true;
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

  # home.file."${config.xdg.configHome}/zellij/config.kdl".source = ./config.kdl;
  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
