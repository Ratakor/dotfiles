# Core NixOS utilities in safe, portable Rust for NixOS and friends
# Replaces some of the Perl, Bash and Python scripts used in NixOS
{ sources, ... }:
{
  imports = [ sources.nixos-core.nixosModules.default ];

  system.nixos-core.enable = false;

  # https://github.com/manic-systems/nixos-core/issues/79
  # system.nixos-core.components = {
  #   extraUtilsCommand.enable = false;
  #   bootStage1.enable = false;
  #   initialRamdisk.enable = false;
  #   nixosInitCompat.enable = true;
  # };
}
