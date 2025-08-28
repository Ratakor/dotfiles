# Based on https://github.com/notashelf/nyxexprs and https://github.com/diniamo/niqspkgs
# TODO: setup cachix: see https://github.com/diniamo/niqspkgs/blob/main/.github/workflows/cachix.yaml
# TODO: setup automatic flake.lock update too
{
  inputs,
  self,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  perSystem = {
    config,
    inputs',
    lib,
    pins,
    pkgs,
    ...
  }: let
    inherit (builtins) concatStringsSep match listToAttrs;
    inherit (lib.attrsets) recursiveUpdate;
    inherit (lib.filesystem) packagesFromDirectoryRecursive;
    inherit (lib.customisation) callPackageWith;

    date = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" self.lastModifiedDate);
  in {
    # Add all packages to the default overlay which can be consumed as follows:
    # `nixpkgs.overlays = [inputs.FLAKE_NAME.overlays.default];`
    overlayAttrs = config.packages;

    packages = let
      extraArgs = {inherit pins date;};

      base = packagesFromDirectoryRecursive {
        callPackage = callPackageWith (recursiveUpdate pkgs extraArgs);
        directory = ./pkgs;
      };

      fromInputs = [
        "agenix"
        "flint"
        "watt"
      ];

      mappedPkgs = listToAttrs (map (input: {
          name = input;
          value = inputs'.${input}.packages.default or (throw "Input '${input}' does not provide a default package");
        })
        fromInputs);
    in
      base // mappedPkgs;
  };
}
