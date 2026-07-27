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

      cmd = mkCommandOption "spawn a menu to launch applications";
      emoji = mkCommandOption "spawn a menu to search emojis";
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
