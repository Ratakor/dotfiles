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
      wlib,
      ...
    }:
    let
      inherit (lib.attrsets) recursiveUpdate;
      inherit (lib.customisation) callPackageWith;
      inherit (lib.filesystem) packagesFromDirectoryRecursive;
      inherit (lib.strings) optionalString;
      inherit (lib.trivial) const;

      craneLib = pkgs.callPackage "${pins.crane}/lib" { };
      diskoVersion =
        let
          versionInfo = import "${pins.disko}/version.nix";
        in
        versionInfo.version + (optionalString (!versionInfo.released) "-dirty");
    in
    {
      # Add all packages to the default overlay which can be consumed as follows:
      # `nixpkgs.overlays = [inputs.FLAKE_NAME.overlays.default];`
      overlayAttrs = config.packages;

      packages =
        let
          extraArgs = { inherit pins wlib; };

          base = packagesFromDirectoryRecursive {
            callPackage = callPackageWith (recursiveUpdate pkgs extraArgs);
            directory = ./pkgs;
          };

          fromInputs = { };

          fromPins = {
            # age-encrypted secrets for NixOS
            agenix = pkgs.callPackage "${pins.agenix}/pkgs/agenix.nix" { };
            # Declarative disk partitioning and formatting using nix
            disko = pkgs.callPackage "${pins.disko}/package.nix" { inherit diskoVersion; };
            disko-install = fromPins.disko.overrideAttrs (const {
              name = "disko-install";
            });
            # Stupid simple utility for linting your flake inputs
            flint = pkgs.callPackage "${pins.flint}/nix/package.nix" { };
            # Wayland clipboard "manager"
            stash = pkgs.callPackage "${pins.stash}/nix/package.nix" { inherit craneLib; };
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
            # Helix keybinds for Z Shell
            zsh-helix-mode = pkgs.callPackage "${pins.zsh-helix-mode}/default.nix" { };
          };
        in
        base // fromInputs // fromPins;
    };
}
