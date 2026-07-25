{
  lib,
  self,
  sources,
}:
let
  inherit (lib.customisation) callPackageWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;

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
        inherit (sources.disko.packages.${system}) disko disko-install;

        # Network Printer
        network-printer = pkgs.callPackage "${sources.np}/nix/package.nix" {
          xcb-util-cursor = pkgs.libxcb-cursor;
        };

        # A scrollable-tiling Wayland compositior. Git version.
        # niri-git = sources.niri.packages.${system}.default;

        # Run unpatched binaries on Nix/NixOS
        nix-alien = sources.nix-alien.packages.${system}.default;

        # Source of sources
        tack = sources.tack.packages.${system}.default;

        # CLI tool to restore files from ZFS snapshots
        zfs-restore = pkgs.callPackage "${sources.zfs-restore}/nix/package.nix" { };
      };
    in
    base // fromSources;

  wrappers = packagesFromDirectoryRecursive {
    callPackage = callPackageWith (final // extraArgs);
    directory = ./wrappers;
  };

  scripts = packagesFromDirectoryRecursive {
    callPackage = callPackageWith (pkgs // extraArgs);
    directory = ./scripts;
  };
in
packages // { inherit wrappers scripts; }
