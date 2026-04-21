{
  config,
  lib,
  options,
  self,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str;
  inherit (self.lib.options) mkEnableOptions;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    terminal = mkEnableOptions opt.default.terminal.name;

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
        description = "The command to spawn a terminal emulator in the directory given as argument.";
      };
    };
  };

  config.self.programs = {
    terminal.${cfg.default.terminal.name}.enable = true;
  };
}
