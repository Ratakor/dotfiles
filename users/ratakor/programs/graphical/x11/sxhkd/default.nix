{pkgs, ...}: {
  # TODO
  home.packages = [pkgs.sxhkd];
  xdg.configFile."sxhkd/sxhkdrc".source = ./sxhkdrc;
}
