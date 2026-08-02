# Theme and colors configuration for the system
{ config, lib, ... }:
let
  inherit (builtins) attrNames readDir;
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;

  cfg = config.self.colors;
in
{
  options.self.colors = {
    theme = mkOption {
      type = enum (attrNames (readDir ./themes));
      description = "The colorscheme that should be used globally.";
      default = "gruvbox";
    };

    variant = mkOption {
      type = enum [
        "dark"
        "light"
      ];
      description = "Default variant for the chosen colorscheme.";
      default = "dark";
    };

    dark = mkOption {
      default = import ./themes/${cfg.theme}/dark.nix;
      description = "Dark variant of the chosen colorscheme.";
      readOnly = true;
      internal = true;
    };

    light = mkOption {
      default = import ./themes/${cfg.theme}/light.nix;
      description = "Light variant of the chosen colorscheme.";
      readOnly = true;
      internal = true;
    };

    default = mkOption {
      default = cfg.${cfg.variant};
      description = "Variant of the chosen colorscheme based on the chosen default variant.";
      readOnly = true;
      internal = true;
    };
  };
}
