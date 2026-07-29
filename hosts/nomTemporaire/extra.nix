{ lib, pkgs, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  hm.programs.git = {
    signing.signByDefault = mkForce false;
    settings.url = mkForce { };
  };

  # this doesn't seem to work anyway
  security.pam.services.swaylock.nodelay = true;

  user.packages = with pkgs; [
    obsidian
    joplin-desktop
  ];
}
