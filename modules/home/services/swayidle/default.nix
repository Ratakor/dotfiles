# Idle manager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;

  prg = config.self.programs;
  sys = config.self.system;
in
{
  hm.services.swayidle = {
    enable = sys.displayServer == "wayland";
    extraArgs = [ "-w" ];
    timeouts = [
      {
        timeout = 300;
        command = prg.default.locker.cmd;
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
