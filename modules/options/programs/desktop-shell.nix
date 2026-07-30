{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram;
in
mkVideoProgram config "desktop shell" {
  values = [
    "dms"
    "noctalia"
  ];
  default = "dms";
}
