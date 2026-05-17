{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkForce;
in
{
  services.xserver = {
    # Enable the X11 windowing system
    enable = config.self.system.displayServer.x11;

    # Disable auto-installation of unneeded software
    desktopManager.xterm.enable = mkForce false;
    displayManager.lightdm.enable = mkForce false;
    excludePackages = [ pkgs.xterm ];
  };
}
