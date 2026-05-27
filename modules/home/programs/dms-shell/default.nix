# Dank Material Shell
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  isDefaultBar = prg.default.statusBar.name == "dms";
in
{
  config = mkIf (prg.locker.dms.enable || prg.statusBar.dms.enable) {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "dms ipc bar toggle index 0";
      };
    };

    programs.dms-shell = {
      enable = true;
      systemd.enable = isDefaultBar;
      enableVPN = false;
      enableSystemMonitoring = true;
      enableDynamicTheming = false; # we use wpaperd or swaybg with randwp instead
      enableClipboardPaste = true;
      enableCalendarEvents = true;
      enableAudioWavelength = true;
    };
  };
}
