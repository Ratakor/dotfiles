{
  colors,
  config,
  ...
}: {
  wayland.windowManager.river = {
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
      NIXOS_OZONE_WL = "1"; # enable ozone wayland for chromium and electron based apps
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
}
