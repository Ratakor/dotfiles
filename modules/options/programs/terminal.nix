{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.modules) mkIf;
  inherit (lib.types)
    nullOr
    enum
    str
    int
    ;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    terminal = mkEnableOptions' opt.default.terminal.name // {
      fontSize = mkOption {
        type = int;
        default = 16;
        description = "Font size used by terminal emulators.";
      };
    };

    default.terminal = {
      name = mkOption {
        type = nullOr (enum [
          "foot"
          "ghostty"
        ]);
        default = if sys.video.enable then "ghostty" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "ghostty" else null
        '';
        description = ''
          The default terminal emulator to use.
          This will automatically enable the corresponding program.
        '';
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn a terminal emulator.";
        default = "dummy-terminal";
        internal = true;
      };

      cmdDir = mkOption {
        type = str;
        # readOnly makes it so that an option can be assigned only one time
        # except that it doesn't take mkIf into account so it sucks
        # readOnly = true;
        description = "The command to spawn a terminal emulator in the directory given as argument.";
        # default = "dummy-terminal";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.terminal.name != null) {
    terminal.${cfg.default.terminal.name}.enable = true;
  };
}
