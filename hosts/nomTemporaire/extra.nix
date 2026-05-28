{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  hm.programs.git = {
    signing.signByDefault = mkForce false;
    settings.url = mkForce { };
  };
}
