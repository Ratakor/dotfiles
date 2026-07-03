{ lib, pkgs, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  services.xserver = {
    enable = false; # no X11 support, Wayland is the future, take that chud 🫵

    # Disable auto-installation of unneeded software
    desktopManager.xterm.enable = mkForce false;
    displayManager.lightdm.enable = mkForce false;
    excludePackages = [ pkgs.xterm ];
  };
}
