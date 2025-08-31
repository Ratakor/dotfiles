{
  colors,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = false; # TODO
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
      # enableXdgAutostart = true;
    };

    # plugins = [];

    # settings = {};
  };
}
