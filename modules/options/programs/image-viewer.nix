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
    mkPackageOption
    mkEnableOptions'
    literalExpression
    ;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    imageViewer = mkEnableOptions' odprg.imageViewer.name;

    default.imageViewer = {
      name = mkOption {
        type = nullOr (enum [
          "imv"
        ]);
        default = if sys.video.enable then "imv" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "imv" else null
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

  config.self.programs = mkIf (dprg.imageViewer.name != null) {
    imageViewer.${dprg.imageViewer.name}.enable = true;
  };
}
