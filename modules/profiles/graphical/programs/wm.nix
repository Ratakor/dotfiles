{ config, ... }:
{
  programs = {
    # TODO
    # Window Manager
    river-classic.enable = config.self.windowManager == "river-classic"; # river mop when?
    hyprland.enable = config.self.windowManager == "hyprland";
    niri.enable = config.self.windowManager == "niri";

    # uwsm = {
    #   enable = true;
    #   waylandCompositors = {
    #     river = {
    #       prettyName = "River";
    #       binPath = "/run/current-system/sw/bin/river";
    #     };
    #   };
    # };
  };
}
