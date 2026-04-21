# Dank Material Shell
{ config, ... }:
let
  prg = config.self.programs;
in
{
  programs.dms-shell = {
    enable = prg.locker.dms.enable || prg.statusBar.dms.enable; # || prg.launcher.dms.enable;
    systemd.enable = prg.default.statusBar.name == "dms";
    enableVPN = false;
    enableSystemMonitoring = true;
    enableDynamicTheming = false; # we use swaybg with randwp
    enableClipboardPaste = true;
    enableCalendarEvents = true;
    enableAudioWavelength = true;
  };
}
