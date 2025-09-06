{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) types;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;

  yaml = pkgs.formats.yaml {};

  cfg = config.wrap.programs.glow;
in {
  options.wrap.programs.glow = {
    enable = mkEnableOption "Glow";
    package = mkPackageOption pkgs "glow" {};

    settings = mkOption {
      type = yaml.type;
      default = {};
    };

    wrapped = mkOption {
      type = types.package;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    wrap.programs.glow.wrapped = self.lib.wrapWith pkgs {
      basePackage = cfg.package;
      prependFlags = [
        "--config"
        (yaml.generate "glow.yml" cfg.settings)
      ];
    };
  };
}
