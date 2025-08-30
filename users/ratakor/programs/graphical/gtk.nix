{
  colors,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      inherit (colors.gtk) name;
      package = pkgs.${colors.gtk.packageName};
    };

    gtk2.enable = false; # .gtkrc-2.0 symlink in $HOME

    # TODO:
    # - does this work as intended on X11?
    # - iirc it was causing issue with lutris on wayland
    # - try to only remove titlebar for specific apps (terminal, dragon-drop, ...)
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
      # TODO: config
      enable = false;
    };
  };
}
