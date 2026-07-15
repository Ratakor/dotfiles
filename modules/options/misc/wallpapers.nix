{ lib, pkgs, ... }:
let
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.types) path;
in
{
  options.self.wallpapers = mkOption {
    type = path;
    default = pkgs.wallpapers;
    defaultText = literalExpression ''
      pkgs.wallpapers
    '';
    description = "Directory with all available wallpapers.";
  };
}
