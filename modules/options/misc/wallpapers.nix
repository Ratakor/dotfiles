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
    # TODO: version = sources.wallpapers.metadata.lastModified
    # depends on https://github.com/manic-systems/tack/pull/84
    default = pkgs.callPackage "${sources.wallpapers}/package.nix" { };
    defaultText = literalExpression ''
      pkgs.callPackage "''${sources.wallpapers}/package.nix" { }
    '';
    description = "Directory with all available wallpapers.";
  };
}
