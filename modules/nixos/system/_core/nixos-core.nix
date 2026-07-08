# Core NixOS utilities in safe, portable Rust for NixOS and friends
# Replaces some of the Perl, Bash and Python scripts used in NixOS
{ sources, ... }:
{
  imports = [ sources.nixos-core.nixosModules.default ];

  system.nixos-core.enable = true;
}
