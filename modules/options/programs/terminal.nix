{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram mkOption;
  inherit (lib.types) int;
in
mkVideoProgram config "terminal emulator" {
  values = [
    "foot"
    "ghostty"
  ];
  default = "ghostty";
  optionPath = [ "terminal" ];
  commands = {
    cmd = "spawn the default terminal emulator";
    cmdDir = "spawn the default terminal emulator in the directory given as argument";
  };
  extraOptions = {
    fontSize = mkOption {
      type = int;
      default = 16;
      description = "Font size used by terminal emulators.";
    };
  };
}
