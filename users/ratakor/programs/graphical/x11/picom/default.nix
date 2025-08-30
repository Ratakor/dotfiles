{pkgs, ...}: {
  # TODO
  home.packages = [pkgs.picom];
  xdg.configFile."picom.conf".source = ./picom.conf;
}
