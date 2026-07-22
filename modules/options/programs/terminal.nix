{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib) types;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    terminal = mkEnableOptions' odprg.terminal.name // {
      fontSize = mkOption {
        type = types.int;
        default = 16;
        description = "Font size used by terminal emulators.";
      };
    };

    default.terminal = {
      name = mkOption {
        type = types.nullOr (
          types.enum [
            "foot"
            "ghostty"
          ]
        );
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
        type = types.str;
        description = "The command to spawn a terminal emulator.";
        default = "dummy-terminal";
        internal = true;
      };

      cmdDir = mkOption {
        type = types.str;
        # readOnly makes it so that an option can be assigned only one time
        # except that it doesn't take mkIf into account so it sucks
        # readOnly = true;
        description = "The command to spawn a terminal emulator in the directory given as argument.";
        # default = "dummy-terminal";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (dprg.terminal.name != null) {
    terminal.${dprg.terminal.name}.enable = true;
  };
}
