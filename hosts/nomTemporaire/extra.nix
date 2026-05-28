{ lib, sources, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  imports = [ "${sources.nixos-hardware}/framework/13-inch/amd-ai-300-series" ];

  hm.programs.git = {
    signing.signByDefault = mkForce false;
    settings.url = mkForce { };
  };
}
