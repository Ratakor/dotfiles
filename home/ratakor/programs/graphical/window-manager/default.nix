{
  colors,
  config,
  ...
}: {
  wayland.windowManager = {
    river = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true; # TODO
        variables = ["--all"];
      };

      extraSessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "river";
        MOZ_ENABLE_WAYLAND = "1";
      };

      settings = {
        focus-follows-cursor = "normal";
        attach-mode = "bottom";
        hide-cursor = ["when-typing enabled"];
        set-cursor-warp = "on-output-change";
        set-repeat = "50 300";
        keyboard-layout = "-variant us -options caps:none fr";
        default-layout = "rivertile";

        background-color = "0x${colors.background}";
        border-color-focused = "0x${colors.blue}";
        border-color-unfocused = "0x${colors.unfocused}";
        border-color-urgent = "0x${colors.red}";
      };

      extraConfig = builtins.readFile ./river-init.sh;
    };

    hyprland = {
      enable = false; # TODO
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
        # enableXdgAutostart = true;
      };

      # plugins = []; # TODO

      # settings = {}; # TODO
    };
  };

  # so this is quite ugly but:
  # - niri is not yet available in home-manager (I know about niri-flake but
  #   it's different from the above WMs config)
  # - niri has hot reloading so it's better if the config is mutable
  # - tbh it wouldn't be ugly if mkOutOfStoreSymlink worked with relative paths
  xdg.configFile."niri/config.kdl".source = "${config.home.dotfiles}/programs/graphical/window-manager/niri-config.kdl";
}
