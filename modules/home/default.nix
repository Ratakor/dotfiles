{
  lib,
  self,
  ...
}: let
  inherit (builtins) concatLists;
  inherit (lib.lists) singleton;
  inherit (self.lib.filesystem) listFiles;

  packages = singleton ./packages;
  programs = listFiles ./programs;
  services = listFiles ./services;
in {
  imports = concatLists [
    packages
    programs
    services
  ];
}
