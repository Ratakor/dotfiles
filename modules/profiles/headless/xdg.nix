{ lib, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib.modules) mkForce;
in
{
  xdg = mapAttrs (_: mkForce) {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    portal.enable = false;
    sounds.enable = false;
  };
}
