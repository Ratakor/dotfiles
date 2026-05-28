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

  dolphin = optional prg.fileManager.dolphin.enable pkgs.kdePackages.dolphin;
in
{
  config = {
    self.programs.default.fileManager = mkIf (dprg.fileManager.name == "dolphin") {
      desktopEntry = "org.kde.dolphin.desktop";
    };

    xdg.portal = mkIf prg.xdg.portal.kde.enable {
      extraPortals = mkForce [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };

    services.dbus.packages = dolphin;
    user.packages = dolphin;
  };
}
