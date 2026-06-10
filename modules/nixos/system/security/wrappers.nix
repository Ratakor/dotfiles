{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  # Disable suid wrappers for unused binaries.
  # There may be other wrappers to consider disabling.
  security.wrappers = {
    su.enable = mkForce false;
    sg.enable = mkForce false;
    pkexec.enable = mkForce false;
  };
}
