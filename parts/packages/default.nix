# Based on https://github.com/notashelf/nyxexprs and https://github.com/diniamo/niqspkgs
{
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  perSystem =
    {
      system,
      config,
      inputs',
      lib,
      pins,
      pkgs,
      ...
    }:
    let
      inherit (builtins) concatStringsSep match;
      inherit (lib.attrsets) recursiveUpdate mapAttrs' nameValuePair;
      inherit (lib.filesystem) packagesFromDirectoryRecursive;
      inherit (lib.customisation) callPackageWith;
      inherit (self.lib.filesystem) listFiles;

      date = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" self.lastModifiedDate);
    in
    {
      # Add all packages to the default overlay which can be consumed as follows:
      # `nixpkgs.overlays = [inputs.FLAKE_NAME.overlays.default];`
      overlayAttrs = config.packages;

      packages =
        let
          extraArgs = { inherit pins date; };

          base = packagesFromDirectoryRecursive {
            callPackage = callPackageWith (recursiveUpdate pkgs extraArgs);
            directory = ./pkgs;
          };

          wrappers =
            let
              wrapper-manager = import pins.wrapper-manager;
              wm-eval = wrapper-manager.lib.eval {
                # Using `pkgs` causes an infinite recursion
                pkgs = inputs'.nixpkgs.legacyPackages;
                modules = listFiles ./wrappers;
              };
            in
            mapAttrs' (n: v: nameValuePair (n + "-wrapped") v.wrapped) wm-eval.config.wrappers;

          fromInputs = { };

          fromPins = {
            # age-encrypted secrets for NixOS
            agenix = pkgs.callPackage "${pins.agenix}/pkgs/agenix.nix" { };
            # Stupid simple utility for linting your flake inputs
            flint = pkgs.callPackage "${pins.flint}/nix/package.nix" { };
            # Automatic CPU speed & power optimizer for Linux
            watt = pkgs.callPackage "${pins.watt}/nix/package.nix" { };
            # CLI tool to restore files from ZFS snapshots
            zfs-restore = pkgs.callPackage "${pins.zfs-restore}/nix/package.nix" {
              zig = pkgs.zig_0_15;
            };
            # CLI/TUI for Spotify
            zpotify = pkgs.callPackage "${pins.zpotify}/nix/package.nix" {
              zig = pkgs.zig_0_15;
              image-support = true;
            };
          };
        in
        base // wrappers // fromInputs // fromPins;
    };
}
