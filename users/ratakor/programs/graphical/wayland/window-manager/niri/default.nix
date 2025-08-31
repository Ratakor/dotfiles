{config, ...}: {
  # so this is quite ugly but:
  # - niri is not yet available in home-manager (I know about niri-flake but
  #   it's different from the above WMs config)
  # - niri has hot reloading so it's better if the config is mutable
  # - tbh it wouldn't be ugly if mkOutOfStoreSymlink worked with relative paths
  xdg.configFile."niri/config.kdl".source = "${config.home.dotfiles}/programs/graphical/wayland/window-manager/niri/niri-config.kdl";
}
