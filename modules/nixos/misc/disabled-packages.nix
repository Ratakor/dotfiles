{ config, ... }:
let
  inherit (builtins) listToAttrs;
in
{
  nixpkgs.overlays = [
    (
      _final: prev:
      listToAttrs (
        map (name: {
          inherit name;
          value = prev.emptyDirectory;
        }) config.self.disabledPackages
      )
    )
  ];
}
