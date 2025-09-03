# This is kind of barebones atm maybe set everything into a single namespace and
# improve type system for colors. Also move specific programs theme to their own options?
{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in {
  options.colorscheme = mkOption {
    type = enum ["gruvbox-dark" "gruvbox-light" "dracula"];
    description = "The colorscheme that should be used globally.";
    default = "gruvbox-dark";
  };

  options.colors = mkOption {
    default = import ./${config.colorscheme}.nix;
    readOnly = true;
  };
}
