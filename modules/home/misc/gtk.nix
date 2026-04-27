{
  config,
  lib,
  pkgs,
  ...
}:
let
  theme = config.self.colors.default.gtk.theme pkgs;
in
{
  hm.gtk = {
    enable = true;

    inherit theme;

    gtk2.enable = false; # .gtkrc-2.0 symlink in $HOME

    # TODO:
    # - does this work as intended on X11?
    # - iirc it was causing issue with lutris on wayland
    # - try to only remove titlebar for specific apps (terminal, dragon-drop, ...)
    # - idk if it's because of this or odd gtk4 config but chromium looses its bar when fullscreen
    # TODO: check if disabling that fixes anything
    gtk3.extraCss = lib.mkIf false /* css */ ''
      /* No (default) titlebar on wayland */
      .titlebar, .css, headerbar {
          background-image: none;
          background-color: transparent;
          margin-top: -100px;
          margin-bottom: 50px;
      }
    '';

    gtk4 = {
      inherit theme;
      extraConfig = {
        # gtk-application-prefer-dark-theme = true;
        # gtk-decoration-layout = "appmenu:none";
      };
    };
  };
}
