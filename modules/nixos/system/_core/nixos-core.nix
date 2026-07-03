# Core NixOS utilities in safe, portable Rust for NixOS and friends
# Replaces some of the Perl, Bash and Python scripts used in NixOS
{ lib, sources, ... }:
let
  # It's a little annoying to import the module manually and there isn't much
  # downside to using flake-compat.
  nixos-core = lib.flakes.compat' sources.nixos-core;
in
{
  imports = [ nixos-core.nixosModules.default ];

  system.nixos-core.enable = true;
}
