{pkgs, ...}: {
  programs = {
    # It may not look like it but this is the greatest software in existence
    pmount.enable = true;

    gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];
  };
}
