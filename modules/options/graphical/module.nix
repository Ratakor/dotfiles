{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in {
  imports = [
    ./menu.nix
  ];

  # move to displayManager.wayland.enable?
  # replace profiles.graphical?
  options.self = {
    displayServer = mkOption {
      type = enum ["x11" "wayland"];
      default = "wayland";
      description = "The display server to use.";
    };
  };
}
