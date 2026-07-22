{ config, lib, ... }:
let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.trivial) const;
in
{
  nixpkgs.overlays = [
    (_final: prev: genAttrs config.self.disabledPackages (const prev.emptyDirectory))
  ];
}
