# Daemon-less notifications without D-Bus
{pkgs, ...}: let
  herbe = pkgs.herbe.override {
    patches = [./herbe.diff];
    extraLibs = [pkgs.xorg.libXrandr];
  };
in {
  # TODO: this segfaults, idk why and I cba looking into it rn
  # user.packages = [herbe];
}
