{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) optional;

  prg = config.self.programs;
  dprg = prg.default;
  cfg = prg.xdg.portal.gnome;

  nautilus = optional prg.fileManager.nautilus.enable pkgs.nautilus;
in
{
  config = {
    self.programs.default.fileManager = mkIf (dprg.fileManager.name == "nautilus") {
      desktopEntry = "org.gnome.Nautilus.desktop";
    };

    xdg.portal = mkIf cfg.enable {
      enable = true;
      extraPortals = mkForce [
        pkgs.xdg-desktop-portal-gnome
        pkgs.gnome-keyring
      ];
    };

    user.packages = nautilus;
    services = {
      dbus.packages = nautilus;

      udev.packages = [ pkgs.gnome-settings-daemon ];

      gnome = {
        gnome-keyring.enable = cfg.enable;
      };
    };

    # A GNOME application for managing encryption keys and passwords in the GNOME Keyring.
    programs.seahorse.enable = cfg.enable;
  };
}
