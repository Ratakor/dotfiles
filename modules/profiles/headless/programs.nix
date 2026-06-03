{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  programs = {
    nano.enable = false; # use helix instead :P
    command-not-found.enable = mkForce false;
  };
}
