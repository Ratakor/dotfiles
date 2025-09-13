# This is kind of barebones atm maybe set everything into a single namespace and
# improve type system for colors. Also move specific programs theme to their own options?
# The comment above is maybe lying.
# Maybe revert this into a global module without options
# Also the naming in wrong for bright, it should be bright.<color> instead.
# TODO: Add colors' which is colors but format #rrggbb
# colors' = builtins.mapAttrs (_: c: "#${c}") colors;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;

  cfg = config.self;
in
{
  options.self = {
    colorscheme = mkOption {
      type = enum [
        "gruvbox-dark"
        "gruvbox-light"
        "dracula"
      ];
      description = "The colorscheme that should be used globally.";
      default = "gruvbox-dark";
    };

    colors = mkOption {
      default = import ./${cfg.colorscheme}.nix pkgs;
      readOnly = true;
    };
  };
}
