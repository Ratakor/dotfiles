{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) length;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;

  randwp = pkgs.scripts.randwp.override {
    isWayland = true;
    supportMultipleMonitors = true; # length config.self.device.monitors > 1;
    wallpapers = config.hm.xdg.userDirs.extraConfig.WALLPAPERS;
  };

  prg = config.self.programs;
  dprg = prg.default;
in
{
  config = mkIf prg.wallpaper.randwp.enable {
    self.programs.default.wallpaper = mkIf (dprg.wallpaper.name == "randwp") {
      nextRandom = "randwp";
      set = "randwp";
    };

    user.packages = [ randwp ];

    systemd.user.services.randwp = {
      description = "Set a random wallpaper";

      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = getExe randwp;

        # this is really dirty but the proper fix would be to rewrite randwp to
        # have better interaction with systemd and to actually be a daemon
        KillMode = "none";
      };
    };

    systemd.user.timers.randwp = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "15min"; # i can't decide between 15min or 30min :3
        Unit = "randwp.service";
      };
    };
  };
}
