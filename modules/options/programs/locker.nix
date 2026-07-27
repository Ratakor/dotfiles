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
    # rename to lock?
    locker = mkEnableOptions' odprg.locker.name;

    default.locker = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "glitchlock" # backed by swaylock
          "noctalia"
          "swaylock"
        ]);
        default = dprg.desktopShell.name;
        defaultText = literalExpression ''
          dprg.desktopShell.name
        '';
        description = ''
          The default screen locker to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };

      cmd = mkCommandOption "spawn the default screen locker";
    };
  };

  config = mkIf (dprg.locker.name != null) {
    assertions = [
      {
        assertion = prg.desktopShell ? ${dprg.locker.name} -> prg.desktopShell.${dprg.locker.name}.enable;
        message = "The corresponding desktop shell must be enabled for locker.";
      }
    ];

    self.programs.locker.${dprg.locker.name}.enable = true;
  };
}
