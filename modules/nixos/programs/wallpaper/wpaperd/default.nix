# Wallpaper Daemon
# See `wpaperctl` to control the daemon.
# btw super cool stuff, wpaperd creates symlinks in $XDG_STATE_HOME/wpaperd/wallpapers
# that points to the current wallpaper used.
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  dprg = prg.default;
in
{
  config = mkIf prg.wallpaper.wpaperd.enable {
    # it would be weird for it to not be the default if it is enabled but whatever
    self.programs.default.wallpaper = mkIf (dprg.wallpaper.name == "wpaperd") {
      nextRandom = "wpaperctl next";
      set = "wpaperctl set";
      get = "wpaperctl get-all";
    };

    hm.services.wpaperd = {
      enable = true;
      settings.default = {
        path = config.hm.xdg.userDirs.extraConfig.WALLPAPERS;
        duration = "15m";
        sorting = "random";
        mode = "center";
        transition-time = 400; # default: 300
        queue-size = 5; # default: 10
        initial-transition = true; # default: true
        recursive = true; # default: true
        # exec =

        # colour-distance goes hard too
        transition.glitch-memories = { };
      };
    };
  };
}
