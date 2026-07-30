{ config, lib, ... }:
let
  inherit (lib.options) mkDesktopShellProgram;
in
mkDesktopShellProgram config "launcher" {
  values = [
    "dms"
    "fuzzel"
    "noctalia"
    "tofi"
    "vicinae"
    "walker"
  ];
  commands = {
    cmd = "spawn a menu to launch applications";
    emoji = "spawn a menu to search emojis";
  };
}
