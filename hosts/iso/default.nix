{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  networking.hostName = mkForce "nixos";

  # TODO: some of iso profile should be here instead
}
