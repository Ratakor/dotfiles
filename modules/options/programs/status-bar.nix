# This should probably be in services not programs.
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.modules) mkIf;
  inherit (lib.types) nullOr enum str;

  opt = options.self.programs;
  prg = config.self.programs;
  dprg = prg.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    statusBar = mkEnableOptions' opt.default.statusBar.name;

    default.statusBar = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
          "sb"
          "waybar"
        ]);
        default = if sys.displayServer.x11 then "sb" else dprg.desktopShell.name;
        defaultText = literalExpression ''
          if sys.displayServer.x11 then "sb" else dprg.desktopShell.name;
        '';
        description = ''
          The default status bar to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };

      toggle = mkOption {
        type = str;
        description = "The command to toggle the default status bar.";
        # default = "dummy-status-bar";
        internal = true;
      };
    };
  };

  config = mkIf (dprg.statusBar.name != null) {
    assertions = [
      {
        assertion = prg.desktopShell ? ${dprg.locker.name} -> prg.desktopShell.${dprg.locker.name}.enable;
        message = "The corresponding desktop shell must be enabled for locker.";
      }
    ];

    self.programs.statusBar.${dprg.statusBar.name}.enable = true;
  };
}
