{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self = {
    docs.enable = mkEnableOption "generation of internal module documentation to `/etc/nixos/docs`";
  };
}
