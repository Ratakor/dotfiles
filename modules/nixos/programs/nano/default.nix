{ lib, ... }:
{
  # gtfo bozo
  programs.nano.enable = lib.mkForce false;
}
