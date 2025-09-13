# Hyprland is an independent, highly customizable, dynamic tiling Wayland
# compositor that doesn't sacrifice on its looks.
# TODO
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.windowManager == "hyprland") {
    programs.hyprland.enable = true;

    hm.wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
        # enableXdgAutostart = true;
      };

      # plugins = [];

      # settings = {};
    };
  };
}
