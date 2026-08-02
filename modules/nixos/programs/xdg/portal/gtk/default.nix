{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;

  cfg = config.self.programs.xdg.portal.gtk;
in
{
  user.packages = with pkgs; [
    glib # gsettings
    nwg-look # Graphical GTK settings
  ];

  xdg.portal = mkIf cfg.enable {
    enable = true;
    extraPortals = mkForce [ pkgs.xdg-desktop-portal-gtk ];
  };

  hm.gtk = {
    enable = true;

    theme = {
      # let desktop shells handle the actual theming
      # for noctalia it is automatic via a template hook
      # for dms it's a button to press in System App Theming
      # for non-desktop shell users well idk diy
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus"; # there is also Papirus-{Light,Dark} but ig this does both
      package = pkgs.papirus-icon-theme;
    };

    gtk2.enable = false; # .gtkrc-2.0 symlink in $HOME

    # This was needed on river but it's causing issue on niri.
    gtk3.extraCss = mkIf false /* css */ ''
      /* No (default) titlebar on wayland */
      .titlebar, .css, headerbar {
          background-image: none;
          background-color: transparent;
          margin-top: -100px;
          margin-bottom: 50px;
      }
    '';

    gtk4 = {
      inherit (config.hm.gtk) theme;
      extraConfig = {
        # gtk-application-prefer-dark-theme = true;
        # gtk-decoration-layout = "appmenu:none";
      };
    };
  };
}
