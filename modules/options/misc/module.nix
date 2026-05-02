# Miscellaneous options
{
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) types;
in
{
  options.self = {
    docs.enable = mkEnableOption "generation of internal module documentation to `/etc/nixos/docs`";
    wallpapers = mkOption {
      type = types.path;
      default = pkgs.callPackage "${sources.wallpapers}/package.nix" {
        version = lib.shortRev sources.wallpapers.revision;
      };
      description = "Directory with all available wallpapers.";
    };
  };
}
