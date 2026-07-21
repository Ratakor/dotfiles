# Now this should really be in services not programs BUT it actually make sense to put in programs
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.modules) mkIf;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  options.self.programs = {
    # is this useful? why would smn want multiple notification daemon
    notification = mkEnableOptions' opt.default.notification.name;

    # because notificationDaemon was way too verbose
    default.notification = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "mako"
          "noctalia"
        ]);
        default = dprg.desktopShell.name;
        defaultText = literalExpression ''
          dprg.desktopShell.name
        '';
        description = ''
          The default notification daemon to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };
    };
  };

  config = mkIf (dprg.notification.name != null) {
    assertions = [
      {
        assertion =
          prg.desktopShell ? ${dprg.notification.name} -> prg.desktopShell.${dprg.notification.name}.enable;
        message = "The corresponding desktop shell must be enabled for notification daemon.";
      }
    ];

    self.programs.notification.${dprg.notification.name}.enable = true;
  };
}
