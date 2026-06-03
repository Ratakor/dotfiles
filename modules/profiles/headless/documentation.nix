{ lib, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib.modules) mkForce;
in
{
  documentation = mapAttrs (_name: mkForce) {
    enable = false;
    dev.enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };
}
