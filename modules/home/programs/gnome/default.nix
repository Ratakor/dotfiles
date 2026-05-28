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

  nautilus = optional prg.fileManager.nautilus.enable pkgs.nautilus;
in
{
  config = {
    self.programs.default.fileManager = mkIf (dprg.fileManager.name == "nautilus") {
      desktopEntry = "org.gnome.Nautilus.desktop";
    };

    xdg.portal = mkIf prg.xdg.portal.gnome.enable {
      extraPortals = mkForce [ pkgs.xdg-desktop-portal-gnome ];
    };

    services.dbus.packages = nautilus;
    user.packages = nautilus;
  };
}
