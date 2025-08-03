{
  pkgs,
  ...
}: {
  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
  };

  # TODO: config through nix?

  xdg.configFile."river/init".source = ./init;
}
