{
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkForce;
in
{
  hm.imports = [ "${sources.nix-index-database}/home-manager-module.nix" ];

  hm.programs = {
    # A file database for nixpkgs
    nix-index = {
      enable = true;
      symlinkToCacheHome = true;
      enableZshIntegration = false; # We use comma instead
      enableNushellIntegration = true;
    };
    # A combination of nix-index and nix run
    nix-index-database.comma.enable = true;
    # afaik this uses nix-channel which we do not support
    command-not-found.enable = mkForce false;
  };
}
