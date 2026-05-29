# Dank Material Shell
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  dprg = prg.default;
  isDefaultBar = dprg.statusBar.name == "dms";
in
{
  config = mkIf prg.desktopShell.dms.enable {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "dms ipc bar toggle index 0";
      };
      locker = mkIf (dprg.locker.name == "dms") {
        cmd = "dms ipc lock lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == "dms") {
        cmd = "dms ipc powermenu toggle";
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
