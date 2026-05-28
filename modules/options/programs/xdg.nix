{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum;
  inherit (lib.attrsets) recursiveUpdate;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    xdg.portal = recursiveUpdate (mkEnableOptions' opt.default.xdg.portal.name) {
      gtk.enable = {
        default = sys.video.enable;
        defaultText = literalExpression "sys.video.enable";
      };
    };

    default.xdg.portal = {
      name = mkOption {
        type = nullOr (enum [
          "gnome"
          "gtk"
          "kde"
        ]);
        default = if sys.video.enable then "gtk" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "gtk" else null;
        '';
        description = ''
          The default XDG Portal to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config.self.programs = mkIf (cfg.default.xdg.portal.name != null) {
    xdg.portal.${cfg.default.xdg.portal.name}.enable = mkDefault true;
  };
}
