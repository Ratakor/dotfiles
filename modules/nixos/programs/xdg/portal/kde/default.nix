{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) optional;

  sys = config.self.system;
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
      enable = true;
      extraPortals = mkForce [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };

    services.dbus.packages = dolphin;
    user.packages = dolphin;

    # https://docs.noctalia.dev/v5/templates/official/gtk-qt/?section=qt-applications#qt-applications
    # idk between kde, qt5ct or manually implem the module for qt6ct but it seems to work
    qt = {
      inherit (sys.video) enable; # ig that's a saner default than `true`
      platformTheme = "kde"; # "qt5ct"
    };
  };
}
