# Based on https://github.com/notashelf/nyxexprs and https://github.com/diniamo/niqspkgs
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
    inherit (builtins) concatStringsSep match;
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

      fromInputs = {
        # Automatic CPU speed & power optimizer for Linux
        watt = inputs'.watt.packages.default;
        # A CLI tool to restore files from ZFS snapshots
        zfs-restore = inputs'.zfs-restore.packages.default;
      };

      fromPins = {
        # age-encrypted secrets for NixOS
        agenix = pkgs.callPackage "${pins.agenix}/pkgs/agenix.nix" {};
        # Stupid simple utility for linting your flake inputs
        flint = pkgs.callPackage "${pins.flint}/nix/package.nix" {};
      };
    in
      base // fromInputs // fromPins;
  };
}
