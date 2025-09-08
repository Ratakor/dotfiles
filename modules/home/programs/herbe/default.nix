# Daemon-less notifications without D-Bus
{ pkgs, ... }: let
  herbe = pkgs.herbe.override {
    patches = [./herbe.diff];
  };
in {
  # TODO: options
  # user.packages = [herbe];
}
