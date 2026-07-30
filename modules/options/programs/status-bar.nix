# This should probably be in services not programs.
{ config, lib, ... }:
let
  inherit (lib.options) mkDesktopShellProgram;
in
mkDesktopShellProgram config "status bar" {
  values = [
    "dms"
    "noctalia"
    "waybar"
  ];
  commands = {
    toggle = "toggle the default status bar";
  };
}
