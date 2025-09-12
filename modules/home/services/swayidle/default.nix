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
in
{
  config = mkIf (config.self.displayServer == "wayland") {
    user.packages = [ pkgs.swayidle ];

    hm.services.swayidle = {
      enable = true;
      extraArgs = [ "-w" ];
      timeouts = [
        {
          timeout = 300;
          command = "glitchlock";
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
