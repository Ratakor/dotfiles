{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions;
  inherit (lib.types) enum str int;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    terminal = mkEnableOptions opt.default.terminal.name // {
      fontSize = mkOption {
        type = int;
        default = 10;
        description = "Font size used by terminal emulators.";
      };
    };

    default.terminal = {
      name = mkOption {
        type = enum [
          "foot"
          "ghostty"
          "st"
        ];
        default = if sys.displayServer.wayland then "foot" else "ghostty";
        description = "The default terminal emulator to use.";
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn a terminal emulator.";
      };

      cmdDir = mkOption {
        type = str;
        # readOnly makes it so that an option can be assigned only one time
        # except that it doesn't take mkIf into account so it sucks
        # readOnly = true;
        description = "The command to spawn a terminal emulator in the directory given as argument.";
      };
    };
  };

  config.self.programs = {
    terminal.${cfg.default.terminal.name}.enable = true;
  };
}
