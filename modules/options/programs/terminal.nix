{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options)
    mkOption
    mkEnableOptions'
    literalExpression
    mkCommandOption
    ;
  inherit (lib.types) nullOr enum int;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    terminal = mkEnableOptions' odprg.terminal.name // {
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

      cmd = mkCommandOption "spawn the default terminal emulator";
      cmdDir = mkCommandOption "spawn the default terminal emulator in the directory given as argument";
    };
  };

  config.self.programs = mkIf (dprg.terminal.name != null) {
    terminal.${dprg.terminal.name}.enable = true;
  };
}
