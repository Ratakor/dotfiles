{
  pkgs,
  ...
}: {
  # TODO: config through nix?
  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./init;
  };

  # TODO: hyprland
}
