{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram;
in
mkVideoProgram config "image viewer" {
  values = [
    "imv"
  ];
  default = "imv";
  hasPackage = true;
}
