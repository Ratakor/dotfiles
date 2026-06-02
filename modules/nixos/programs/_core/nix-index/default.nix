{
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkForce;
in
{
  imports = [ "${sources.nix-index-database}/nixos-module.nix" ];

  programs = {
    # A file database for nixpkgs
    nix-index = {
      enable = true;
      enableZshIntegration = false; # We use comma instead
      enableBashIntegration = false; # why is this true by default?
    };

    nix-index-database = {
      enable = true;
      comma.enable = true;
    };

    # afaik this uses nix-channel which we do not support
    command-not-found.enable = mkForce false;
  };

  hj.xdg.cache.files."nix-index/files".source =
    (import sources.nix-index-database { inherit pkgs; }).nix-index-database;
}
