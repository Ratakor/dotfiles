{ lib, ... }:
{
  # what else did you expect?
  services.lvm.enable = lib.mkDefault false;
}
