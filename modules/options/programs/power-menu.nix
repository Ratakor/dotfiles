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
  inherit (lib.types) nullOr enum;

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

      cmd = mkCommandOption "spawn the default power menu";
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
