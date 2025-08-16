{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib callPackage;
in
  lib.makeScope pkgs.newScope (self: {
    luciole-fonts = callPackage ./luciole-fonts {};
    cromite = callPackage ./cromite {};
    zpotify = callPackage ./zpotify {};
    zig-2048 = callPackage ./zig-2048 {};
  })
