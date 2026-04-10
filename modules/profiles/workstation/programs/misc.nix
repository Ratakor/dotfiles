{ pkgs, ... }:
{
  programs = {
    # It may not look like it but this is the greatest software in existence
    pmount.enable = true;

    gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];

    kdeconnect.enable = true;

    dms-shell = {
      enable = true;
      systemd.enable = true;
      enableVPN = false;
      enableSystemMonitoring = true;
      enableDynamicTheming = false; # we use swaybg with randwp
      enableClipboardPaste = true;
      enableCalendarEvents = true;
      enableAudioWavelength = true;
    };
  };
}
