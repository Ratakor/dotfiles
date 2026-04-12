# This is kind of barebones atm maybe set everything into a single namespace and
# improve type system for colors. Also move specific programs theme to their own options?
# The comment above is maybe lying.
# Maybe revert this into a global module without options
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;

  cfg = config.self.colors;
in
{
  options.self.colors = {
    theme = mkOption {
      type = enum [
        "gruvbox"
        "dracula"
      ];
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
      default = import ./themes/${cfg.theme}-dark.nix pkgs;
      description = "Dark variant of the chosen colorscheme.";
      readOnly = true;
    };

    light = mkOption {
      default = import ./themes/${cfg.theme}-light.nix pkgs;
      description = "Light variant of the chosen colorscheme.";
      readOnly = true;
    };

    default = mkOption {
      default = cfg.${cfg.variant};
      description = "Variant of the chosen colorscheme based on the chosen default variant.";
      readOnly = true;
    };

    alternative = mkOption {
      default = cfg.${if cfg.variant == "dark" then "light" else "dark"};
      description = "Alternative variant of the chosen colorscheme based on the chosen default variant.";
      readOnly = true;
    };
  };
}
