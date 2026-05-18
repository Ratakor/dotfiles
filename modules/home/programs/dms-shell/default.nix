# Dank Material Shell
{ config, ... }:
let
  prg = config.self.programs;
  dprg = prg.default;
in
{
  programs.dms-shell = {
    enable = prg.locker.dms.enable || prg.statusBar.dms.enable;
    systemd.enable = dprg.statusBar.name == "dms";
    enableVPN = false;
    enableSystemMonitoring = true;
    enableDynamicTheming = false; # we use wpaperd or swaybg with randwp
    enableClipboardPaste = true;
    enableCalendarEvents = true;
    enableAudioWavelength = true;
  };
}
