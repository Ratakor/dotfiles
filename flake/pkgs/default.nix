{
  lib,
  self,
  sources,
  systems,
}:
let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) genAttrs;

  overlay = import ./overlay.nix { inherit lib self sources; };
  pkgsFor = import ./pkgs.nix { inherit lib sources overlay; };
  legacyPackages = genAttrs systems pkgsFor;
in
{
  overlays.default = overlay;
  inherit legacyPackages;
  packages = mapAttrs (system: pkgs: removeAttrs (overlay pkgs pkgs) [ "wrappers" ]) legacyPackages;
}
