{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.types) nullOr enum str;

  odprg = options.self.programs.default;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  options.self.programs = {
    launcher = mkEnableOptions' odprg.launcher.name;

    default.launcher = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "fuzzel"
          "noctalia"
          "tofi"
          "vicinae"
          "walker"
        ]);
        default = dprg.desktopShell.name;
        defaultText = literalExpression ''
          dprg.desktopShell.name
        '';
        description = ''
          The default launcher to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn a menu to launch applications.";
        # default = "dummy-launcher";
        internal = true;
      };

      emoji = mkOption {
        type = str;
        description = "The command to spawn a menu to find emoji.";
        default = "notify-send 'Unsupported command: emojisearch'";
        internal = true;
      };
    };
  };

  config = mkIf (dprg.launcher.name != null) {
    assertions = [
      {
        assertion =
          prg.desktopShell ? ${dprg.launcher.name} -> prg.desktopShell.${dprg.launcher.name}.enable;
        message = "The corresponding desktop shell must be enabled for launcher.";
      }
    ];

    self.programs.launcher.${dprg.launcher.name}.enable = true;
  };
}
