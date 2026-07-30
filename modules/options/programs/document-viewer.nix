{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram;
in
mkVideoProgram config "document viewer" {
  values = [
    "zathura"
  ];
  default = "zathura";
  hasPackage = true;
}
