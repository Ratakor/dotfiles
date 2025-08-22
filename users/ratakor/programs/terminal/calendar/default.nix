# TODO: aur/quand-git # a calendar app like when
{pkgs, ...}: {
  xdg.configFile."quand/config".source = ./config;
}
