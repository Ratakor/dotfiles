{ lib, ... }:
let
  inherit (lib.modules) mkDefault mkForce;
in
{
  environment = {
    defaultPackages = mkForce [ ];
    stub-ld.enable = false;
    variables.BROWSER = mkDefault "echo";
  };
}
