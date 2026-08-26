# I know this makes things slower as it's exactly like the already existing
# module from nixos beside default but I believe it looks cleaner in each
# host's self.nix and it also appear in the docs.
# Same issue with config.self.keyboard and probably other options.
{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib) types;
in
{
  options.self.system.location = {
    provider = mkOption {
      type = types.enum [
        "manual"
        "geoclue2"
      ];
      default = "manual"; # could be set based on if host is a laptop or a desktop/server
      description = "The location provider to use for determining your location.";
    };

    latitude = mkOption {
      type = types.numbers.between (-90) 90;
      default = 48.8;
      description = "Your current latitude. Default to Paris.";
    };

    longitude = mkOption {
      type = types.numbers.between (-180) 180;
      default = 2.3;
      description = "Your current longitude. Default to Paris.";
    };
  };
}
