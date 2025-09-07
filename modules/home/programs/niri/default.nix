# A scrollable-tiling Wayland compositor
{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  # so this is quite ugly but:
  # - niri is not yet available in home-manager (I know about niri-flake but
  #   it's different from the above WMs config)
  # - niri has hot reloading so it's better if the config is mutable
  # - tbh it wouldn't be ugly if home-manager's `file` could make out of store
  #   symlinks with relative paths
  config = mkIf (config.self.displayServer == "wayland") {
    hm.xdg.configFile."niri/config.kdl".source =
      config.hm.lib.file.mkOutOfStoreSymlink
      "${config.user.home}/nixos/modules/home/programs/niri/niri-config.kdl";
  };
}
