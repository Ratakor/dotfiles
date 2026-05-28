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
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    desktopShell = mkEnableOptions' opt.default.desktopShell.name;

    default.desktopShell = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
        ]);
        default = if sys.displayServer.wayland then "dms" else null;
        defaultText = literalExpression ''
          if sys.displayServer.wayland then "dms" else null;
        '';
        description = ''
          The default desktop shell to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config.self.programs = mkIf (cfg.default.desktopShell.name != null) {
    desktopShell.${cfg.default.desktopShell.name}.enable = true;
  };
}
