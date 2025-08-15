{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib callPackage;
in
  lib.makeScope pkgs.newScope (self: {
    luciole-fonts = callPackage ./luciole-fonts {};
    cromite = callPackage ./cromite {};
  })
