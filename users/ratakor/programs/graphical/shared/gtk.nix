{
  osConfig,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    # TODO
    # inherit (osConfig.colors.gtk) theme;
    theme = {
      inherit (osConfig.colors.gtk) name;
      package = pkgs.${osConfig.colors.gtk.packageName};
    };

    gtk2.enable = false; # .gtkrc-2.0 symlink in $HOME

    # TODO:
    # - does this work as intended on X11?
    # - iirc it was causing issue with lutris on wayland
    # - try to only remove titlebar for specific apps (terminal, dragon-drop, ...)
    # - idk if it's because of this or odd gtk4 config but chromium looses its bar when fullscreen
    gtk3.extraCss = ''
      /* No (default) titlebar on wayland */
      .titlebar, .css, headerbar {
          background-image: none;
          background-color: transparent;
          margin-top: -100px;
          margin-bottom: 50px;
      }
    '';

    gtk4 = {
      enable = true;
      # TODO: config
    };
  };
}
