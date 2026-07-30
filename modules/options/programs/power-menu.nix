{ config, lib, ... }:
let
  inherit (lib.options) mkDesktopShellProgram;
in
mkDesktopShellProgram config "power menu" {
  values = [
    "dms"
    "noctalia"
    "wlogout"
  ];
  commands = {
    cmd = "spawn the default power menu";
  };
}
