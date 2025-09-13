# A scrollable-tiling Wayland compositor
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.windowManager == "niri") {
    # btw this is NixOS's programs not home-manager's programs.
    # guess why we're using this one
    programs.niri.enable = true;

    # so this is quite ugly but:
    # - niri is not yet available in home-manager (I know about niri-flake but
    #   it's different from the above WMs config)
    # - niri has hot reloading so it's better if the config is mutable
    # - tbh it wouldn't be ugly if home-manager's `file` could make out of store
    #   symlinks with relative paths
    #
    # https://github.com/nix-community/home-manager/issues/2085#issuecomment-2022239332
    # https://foodogsquared.one/posts/2023-03-24-managing-mutable-files-in-nixos/
    hm.xdg.configFile."niri/config.kdl".source =
      config.hm.lib.file.mkOutOfStoreSymlink "${config.user.home}/nixos/modules/home/programs/niri/niri-config.kdl";
  };
}
