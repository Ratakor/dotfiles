{pkgs, ...}: {
  # TODO
  home.packages = [pkgs.sx];
  xdg.configFile."sx/sxrc".source = ./sxrc;
  xdg.configFile."sx/gruvbox-dark".source = ./gruvbox-dark;
}
