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
