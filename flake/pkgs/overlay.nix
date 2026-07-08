{
  lib,
  self,
  sources,
}:
let
  inherit (lib.customisation) callPackageWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.strings) optionalString;

  colors = import (self + /modules/options/colors) { };

  extraArgs = { inherit colors sources self; };
in
final: pkgs:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  packages =
    let
      base = packagesFromDirectoryRecursive {
        callPackage = callPackageWith (final // extraArgs);
        directory = ./packages;
      };

      fromSources = {
        # age-encrypted secrets for NixOS
        agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { };

        # Watch anime in cli with Anilist, MAL Integration and Discord RPC
        curd = pkgs.callPackage "${sources.curd}/package.nix" { withMpv = false; };

        # Declarative disk partitioning and formatting using nix
        disko = pkgs.callPackage "${sources.disko}/package.nix" {
          diskoVersion =
            let
              versionInfo = import "${sources.disko}/version.nix";
            in
            versionInfo.version + (optionalString (!versionInfo.released) "-dirty");
        };
        disko-install = fromSources.disko.overrideAttrs {
          name = "disko-install";
        };

        # Ergonomic Nix Helper
        eh = pkgs.callPackage "${sources.eh}/nix/package.nix" { };

        # Stupid simple utility for linting your flake inputs
        flint = pkgs.callPackage "${sources.flint}/nix/package.nix" { };

        # Not a Docs Generator
        # ndg = pkgs.callPackage "${sources.ndg}/nix/packages/ndg/package.nix" { };

        # Network Printer
        network-printer = pkgs.callPackage "${sources.np}/nix/package.nix" {
          xcb-util-cursor = pkgs.libxcb-cursor;
        };

        # A scrollable-tiling Wayland compositior. Git version. Peak usage of flake btw.
        # niri-git = (lib.flakes.package sources.niri system { rust-overlay = { }; }).overrideAttrs {
        #   # well flake-compat isn't perfect but I love it
        #   version = lib.shortRev sources.niri.rev;
        #   __intentionallyOverridingVersion = true;
        # };

        # Run unpatched binaries on Nix/NixOS
        nix-alien =
          (import sources.nix-alien {
            inherit pkgs;
            self = {
              shortRev = lib.shortRev sources.nix-alien.rev;
              inputs = {
                nix-index-database = {
                  packages.${system} = import sources.nix-index-database { inherit pkgs; };
                  inherit (sources.nix-index-database) rev;
                };
                nixpkgs = {
                  inherit (sources.nixpkgs) narHash;
                };
              };
            };
          }).nix-alien;

        # A pull request tracker for Nixpkgs
        npr = pkgs.callPackage "${sources.npr}/package.nix" { rev = lib.shortRev sources.npr.rev; };

        # Source of sources
        tack = sources.tack.packages.${system}.default;

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

  wrappers = packagesFromDirectoryRecursive {
    callPackage = callPackageWith (final // extraArgs);
    directory = ./wrappers;
  };
in
packages // { inherit wrappers; }
