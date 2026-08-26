# I know this makes things slower as it's exactly like the already existing
# module from nixos beside default but I believe it looks cleaner in each
# host's self.nix and it also appear in the docs.
# Same issue with probably other options.
{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str commas;
in
{
  options.self.system.keyboard = {
    layout = mkOption {
      type = str;
      default = "fr";
      description = "Keyboard layout.";
    };

    variant = mkOption {
      type = str;
      default = "us";
      description = "Keyboard variant.";
    };

    options = mkOption {
      type = commas;
      default = "caps:none";
      example = "terminate:ctrl_alt_bksp";
      description = "Keyboard options.";
    };
  };
}
