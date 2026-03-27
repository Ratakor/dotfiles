{
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    enableVPN = false;
    enableSystemMonitoring = true;
    enableDynamicTheming = false; # we use swaybg with randwp
    enableClipboardPaste = true;
    enableCalendarEvents = true;
    enableAudioWavelength = true;
  };
}
