{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;

  colors = config.self.colors.default.gtk pkgs;
  cfg = config.self.programs.xdg.portal.gtk;
in
{
  xdg.portal = mkIf cfg.enable {
    enable = true;
    extraPortals = mkForce [ pkgs.xdg-desktop-portal-gtk ];
  };

  hm.gtk = {
    enable = true;

    inherit (colors) theme iconTheme;

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
      inherit (colors) theme;
      extraConfig = {
        # gtk-application-prefer-dark-theme = true;
        # gtk-decoration-layout = "appmenu:none";
      };
    };
  };
}
