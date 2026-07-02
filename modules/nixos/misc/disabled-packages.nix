{ config, pkgs, ... }:
let
  inherit (builtins) listToAttrs;
in
{
  nixpkgs.overlays = [
    (
      final: prev:
      listToAttrs (
        map (name: {
          inherit name;
          value = pkgs.emptyDirectory;
        }) config.self.disabledPackages
      )
    )
  ];
}
