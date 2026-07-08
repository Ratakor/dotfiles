{
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.types) path;
in
{
  options.self.wallpapers = mkOption {
    type = path;
    default = pkgs.callPackage "${sources.wallpapers}/package.nix" {
      version = lib.shortRev sources.wallpapers.rev;
    };
    defaultText = literalExpression ''
      pkgs.callPackage "''${sources.wallpapers}/package.nix" {
        version = lib.shortRev sources.wallpapers.rev;
      }
    '';
    description = "Directory with all available wallpapers.";
  };
}
