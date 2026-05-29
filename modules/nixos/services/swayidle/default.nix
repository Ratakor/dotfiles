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

  dprg = config.self.programs.default;
  cfg = config.self.services.swayidle;
in
{
  config = mkIf cfg.enable {
    hm.services.swayidle = {
      enable = true;
      extraArgs = [ "-w" ];
      timeouts = [
        {
          timeout = 300;
          command = dprg.locker.cmd;
        }
        # TODO: wlopm doesn't work on niri
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
