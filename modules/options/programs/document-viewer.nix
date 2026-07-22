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
    documentViewer = mkEnableOptions' odprg.documentViewer.name;

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

  config.self.programs = mkIf (dprg.documentViewer.name != null) {
    documentViewer.${dprg.documentViewer.name}.enable = true;
  };
}
