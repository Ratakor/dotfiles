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
          "dms" # fallback to fuzzel for dmenu
          "fuzzel"
          "noctalia" # fallback to fuzzel for dmenu
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

      dmenu = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu like dmenu.";
        default = "dummy-launcher";
        internal = true;
      };

      drun = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from desktop files.";
        # default = "dummy-launcher";
        internal = true;
      };

      run = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from $PATH.";
        # default = "dummy-launcher";
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
