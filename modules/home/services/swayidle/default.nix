# Idle manager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
  hm.services.swayidle = {
    enable = (config.self.system.displayServer == "wayland");
    extraArgs = [ "-w" ];
    timeouts = [
      {
        timeout = 300;
        command = config.self.programs.locker.cmd;
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
}
