{ config, lib, ... }:
let
  inherit (lib.options) mkDesktopShellProgram;
in
mkDesktopShellProgram config "walpaper utility" {
  values = [
    # "awww" # TODO
    "dms"
    "noctalia"
    "randwp" # backed by swaybg
    "wpaperd"
  ];
  optionPath = [ "wallpaper" ];
  commands = {
    nextRandom = "switch to the next random wallpaper";
    set = "set a wallpaper via a given path";
    get = "get the current wallpaper";
  };
}
