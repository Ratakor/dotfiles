{ lib, ... }:
let
  inherit (lib.modules) mkDefault;
in
{
  # what else did you expect?
  services.lvm.enable = mkDefault false;
}
