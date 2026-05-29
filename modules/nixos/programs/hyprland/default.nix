# Hyprland is an independent, highly customizable, dynamic tiling Wayland
# compositor that doesn't sacrifice on its looks.
# TODO
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
  inherit (lib.trivial) unreachable;

  prg = config.self.programs;
in
{
  config = mkIf prg.windowManager.hyprland.enable {
    self.programs.default.windowManager = mkIf (prg.default.windowManager.name == "hyprland") {
      cmd = unreachable; # unimplemented
      session = "hyprland";
    };

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
