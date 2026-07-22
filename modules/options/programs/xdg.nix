{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    xdg.portal = recursiveUpdate (mkEnableOptions' odprg.xdg.portal.name) {
      # gtk is used as fallback
      gtk.enable = {
        default = sys.video.enable;
        defaultText = literalExpression ''
          sys.video.enable
        '';
      };
    };

    default.xdg.portal = {
      name = mkOption {
        type = nullOr (enum [
          "gnome"
          "gtk"
          "kde"
        ]);
        default = if sys.video.enable then "gnome" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "gnome" else null
        '';
        description = ''
          The default XDG Portal to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config.self.programs = mkIf (dprg.xdg.portal.name != null) {
    xdg.portal.${dprg.xdg.portal.name}.enable = true;
  };
}
