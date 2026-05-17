{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  # This should probably be in some headless profile instead but whatever
  services = {
    displayManager.enable = mkForce false;
  };
}
