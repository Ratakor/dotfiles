# Based on https://github.com/notashelf/nyxexprs and https://github.com/diniamo/niqspkgs
{ self, sources, ... }:
{
  imports = [ "${sources.flake-parts}/extras/easyOverlay.nix" ];

  perSystem =
    {
      system,
      config,
      lib,
      pkgs,
      wlib,
      ...
    }:
    let
      inherit (builtins) substring;
      inherit (lib.attrsets) recursiveUpdate;
      inherit (lib.customisation) callPackageWith;
      inherit (lib.filesystem) packagesFromDirectoryRecursive;
      inherit (lib.strings) optionalString;
      inherit (lib.trivial) const;

      craneLib = pkgs.callPackage "${sources.crane}/lib" { };
      diskoVersion =
        let
          versionInfo = import "${sources.disko}/version.nix";
        in
        versionInfo.version + (optionalString (!versionInfo.released) "-dirty");
    in
    {
      # Add all packages to the default overlay which can be consumed as follows:
      # `nixpkgs.overlays = [inputs.FLAKE_NAME.overlays.default];`
      overlayAttrs = config.packages;

      packages =
        let
          extraArgs = { inherit sources wlib; };

          base = packagesFromDirectoryRecursive {
            callPackage = callPackageWith (recursiveUpdate pkgs extraArgs);
            directory = ./pkgs;
          };

          fromSources = {
            # age-encrypted secrets for NixOS
            agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { };
            # Declarative disk partitioning and formatting using nix
            disko = pkgs.callPackage "${sources.disko}/package.nix" { inherit diskoVersion; };
            disko-install = fromSources.disko.overrideAttrs (const {
              name = "disko-install";
            });
            # Stupid simple utility for linting your flake inputs
            flint = pkgs.callPackage "${sources.flint}/nix/package.nix" { };
            # A scrollable-tiling Wayland compositior. Git version. Peak usage of flake btw.
            niri-git = (self.lib.flake.package sources.niri system { rust-overlay = { }; }).overrideAttrs {
              # well flake-compat isn't perfect but I love it
              version = substring 0 7 sources.niri.revision;
              __intentionallyOverridingVersion = true;
            };
            # Source of sources
            npins = pkgs.callPackage "${sources.npins}/npins.nix" { };
            # Wayland clipboard "manager"
            stash = pkgs.callPackage "${sources.stash}/nix/package.nix" { inherit craneLib; };
            # Automatic CPU speed & power optimizer for Linux
            watt = pkgs.callPackage "${sources.watt}/nix/package.nix" { };
            # CLI tool to restore files from ZFS snapshots
            zfs-restore = pkgs.callPackage "${sources.zfs-restore}/nix/package.nix" { };
            # CLI/TUI for Spotify
            zpotify = pkgs.callPackage "${sources.zpotify}/nix/package.nix" { };
            # Helix keybinds for Z Shell
            zsh-helix-mode = pkgs.callPackage "${sources.zsh-helix-mode}/default.nix" { };
          };
        in
        base // fromSources;
    };
}
