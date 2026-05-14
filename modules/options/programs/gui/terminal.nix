{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalMD;
  inherit (lib.modules) mkIf mkDefault;
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
        default = 10;
        description = "Font size used by terminal emulators.";
      };
    };

    default.terminal = {
      name = mkOption {
        type = nullOr (enum [
          "foot"
          "ghostty"
          "st"
        ]);
        default = if sys.displayServer.wayland || sys.displayServer.x11 then "ghostty" else null;
        defaultText = literalMD ''
          `"ghostty"` if using Wayland or X11, `null` otherwise
        '';
        description = ''
          The default terminal emulator to use.
          This will automatically enable the corresponding program.
        '';
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn a terminal emulator.";
        # default = "dummy-terminal";
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
    terminal.${cfg.default.terminal.name}.enable = mkDefault true;
  };
}
