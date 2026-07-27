# This should probably be in services not programs.
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
    # is this useful? why would smn want multiple status bar
    statusBar = mkEnableOptions' odprg.statusBar.name;

    default.statusBar = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
          "waybar"
        ]);
        default = dprg.desktopShell.name;
        defaultText = literalExpression ''
          dprg.desktopShell.name
        '';
        description = ''
          The default status bar to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };

      toggle = mkCommandOption "toggle the default status bar";
    };
  };

  config = mkIf (dprg.statusBar.name != null) {
    assertions = [
      {
        assertion =
          prg.desktopShell ? ${dprg.statusBar.name} -> prg.desktopShell.${dprg.statusBar.name}.enable;
        message = "The corresponding desktop shell must be enabled for status bar.";
      }
    ];

    self.programs.statusBar.${dprg.statusBar.name}.enable = true;
  };
}
