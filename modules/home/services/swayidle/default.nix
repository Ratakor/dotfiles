# Idle manager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

  cfg = config.self;
in
{
  config = mkIf (cfg.displayServer == "wayland") {
    # user.packages = [ pkgs.swayidle ];

    hm.services.swayidle = {
      enable = true;
      extraArgs = [ "-w" ];
      timeouts = [
        {
          timeout = 300;
          command = cfg.locker.cmd;
        }
        {
          timeout = 600;
          command = "${getExe pkgs.wlopm} --off '*'";
          resumeCommand = "${getExe pkgs.wlopm} --on '*'";
        }
        # { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
    };
  };
}
