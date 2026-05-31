{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) optional optionals singleton;

  prg = config.self.programs;
  dprg = prg.default;
  cfg = prg.xdg.portal.kde;

  theme = config.self.colors.default.qt.theme pkgs;
  dolphin = optional prg.fileManager.dolphin.enable pkgs.kdePackages.dolphin;
in
{
  config = {
    self.programs.default.fileManager = mkIf (dprg.fileManager.name == "dolphin") {
      desktopEntry = "org.kde.dolphin.desktop";
    };

    xdg.portal = mkIf cfg.enable {
      enable = true;
      extraPortals = mkForce [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.kdePackages.kwallet
      ];
    };

    environment.systemPackages = optionals cfg.enable [
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwalletmanager
    ];
    user.packages = dolphin;
    services = {
      dbus.packages = dolphin ++ (optional cfg.enable pkgs.kdePackages.kwallet);
    };

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
