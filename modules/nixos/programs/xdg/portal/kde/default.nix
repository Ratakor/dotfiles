{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) optional singleton;

  prg = config.self.programs;
  dprg = prg.default;

  theme = config.self.colors.default.qt.theme pkgs;
  dolphin = optional prg.fileManager.dolphin.enable pkgs.kdePackages.dolphin;
in
{
  config = {
    self.programs.default.fileManager = mkIf (dprg.fileManager.name == "dolphin") {
      desktopEntry = "org.kde.dolphin.desktop";
    };

    xdg.portal = mkIf prg.xdg.portal.kde.enable {
      enable = true;
      extraPortals = mkForce [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };

    services.dbus.packages = dolphin;
    user.packages = dolphin;

    hm.qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kde"; # "qtct" doesn't work with dolphin
      kvantum = {
        enable = true;
        settings.General.theme = theme.name;
        themes = singleton theme.package;
      };
    };
  };
}
