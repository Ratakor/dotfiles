{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOptions'
    literalExpression
    ;
  inherit (lib.modules) mkIf;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    documentViewer = mkEnableOptions' opt.default.documentViewer.name;

    default.documentViewer = {
      name = mkOption {
        type = nullOr (enum [
          "zathura"
        ]);
        default = if sys.video.enable then "zathura" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "zathura" else null
        '';
        description = ''
          The default document viewer to use.
          This will automatically enable the corresponding program.
        '';
      };

      package =
        (mkPackageOption { } "default document viewer" {
          nullable = true;
          default = null;
        })
        // {
          internal = true;
        };
    };
  };

  config.self.programs = mkIf (cfg.default.documentViewer.name != null) {
    documentViewer.${cfg.default.documentViewer.name}.enable = true;
  };
}
