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

    hm.qt =
      let
        qtctSettings = {
          Appearance = {
            custom_palette = false;
            style = "kvantum";
            # icon_theme = "Papirus-Dark";
            color_scheme = "Style's Color";
          };
          # TODO: there should be config.self.style.{colors,fonts} with
          # monospace, sansSerif, ... in fonts
          Fonts = {
            fixed = "\"Agave Nerd Font Mono,12\"";
            general = "\"Luciole,12\"";
          };
        };
      in
      {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kde"; # "qtct" doesn't work with dolphin
        # qt5ctSettings = qtctSettings;
        # qt6ctSettings = qtctSettings;
        kvantum = {
          enable = true;
          settings.General.theme = theme.name;
          themes = singleton theme.package;
        };
      };
  };
}
