{ config, lib, ... }:
let
  inherit (lib.options) mkDesktopShellProgram;
in
# rename to lock?
mkDesktopShellProgram config "locker" {
  values = [
    "dms"
    "glitchlock" # backed by swaylock
    "noctalia"
    "swaylock"
  ];
  commands = {
    cmd = "spawn the default screen locker";
  };
}
