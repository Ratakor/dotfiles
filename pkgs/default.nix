{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) newScope;
  inherit (pkgs.lib) makeScope;
in
  makeScope newScope (self: {
    luciole-fonts = self.callPackage ./luciole-fonts {};
    cromite = self.callPackage ./cromite {};
    zpotify = self.callPackage ./zpotify {};
    zig-2048 = self.callPackage ./zig-2048 {};
  })
