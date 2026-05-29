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
    imageViewer = mkEnableOptions' opt.default.imageViewer.name;

    default.imageViewer = {
      name = mkOption {
        type = nullOr (enum [
          "imv"
        ]);
        default = if sys.video.enable then "imv" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "imv" else null;
        '';
        description = ''
          The default image viewer to use.
          This will automatically enable the corresponding program.
        '';
      };

      package =
        (mkPackageOption { } "default image viewer" {
          nullable = true;
          default = null;
        })
        // {
          internal = true;
        };
    };
  };

  config.self.programs = mkIf (cfg.default.imageViewer.name != null) {
    imageViewer.${cfg.default.imageViewer.name}.enable = true;
  };
}
