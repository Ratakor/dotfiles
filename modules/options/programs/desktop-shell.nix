{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    # is this useful? why would smn want multiple desktop shell
    desktopShell = mkEnableOptions' odprg.desktopShell.name;

    default.desktopShell = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
        ]);
        default = if sys.video.enable then "dms" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "dms" else null
        '';
        description = ''
          The default desktop shell to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config.self.programs = mkIf (dprg.desktopShell.name != null) {
    desktopShell.${dprg.desktopShell.name}.enable = true;
  };
}
