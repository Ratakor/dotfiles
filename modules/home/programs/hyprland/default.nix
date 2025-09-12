# Hyprland is an independent, highly customizable, dynamic tiling Wayland
# compositor that doesn't sacrifice on its looks.
# TODO
{ config, ... }:
{
  hm.wayland.windowManager.hyprland = {
    enable = false && config.self.displayServer == "wayland";
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
      # enableXdgAutostart = true;
    };

    # plugins = [];

    # settings = {};
  };
}
