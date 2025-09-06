{
  pkgs,
  self,
  ...
}: {
  self.programs.pmount.enable = true;

  programs = {
    gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];
  };
}
