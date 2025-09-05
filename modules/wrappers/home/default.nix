{
  lib,
  self,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (self.lib.filesystem) listFiles;

  packages = []; #singleton ./packages.nix;
  programs = listFiles ./programs;
  services = []; #listFiles ./services;
in {
  imports = packages ++ programs ++ services;
}
