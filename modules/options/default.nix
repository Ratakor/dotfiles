# One solution to remove this file could be to outsource colors.
{ lib, ... }:
{
  imports =
    lib.singleton ./colors/option.nix
    ++ builtins.concatMap lib.listFilesRecursive [
      ./device
      ./misc
      ./programs
      ./services
      ./system
      ./user
    ];
}
