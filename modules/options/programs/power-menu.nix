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
    powerMenu = mkEnableOptions' odprg.powerMenu.name;

    default.powerMenu = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
          "wlogout"
        ]);
        default = dprg.desktopShell.name;
        defaultText = literalExpression ''
          dprg.desktopShell.name
        '';
        description = ''
          The default power menu to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn the default power menu.";
        # default = "dummy-power-menu";
        internal = true;
      };
    };
  };

  config = mkIf (dprg.powerMenu.name != null) {
    assertions = [
      {
        assertion =
          prg.desktopShell ? ${dprg.powerMenu.name} -> prg.desktopShell.${dprg.powerMenu.name}.enable;
        message = "The corresponding desktop shell must be enabled for power menu.";
      }
    ];

    self.programs.powerMenu.${dprg.powerMenu.name}.enable = true;
  };
}
