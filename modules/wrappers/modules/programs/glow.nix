{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;

  cfg = config.programs.glow;

  yamlFormat = pkgs.formats.yaml {};
in {
  options.programs.glow = {
    enable = mkEnableOption "Glow";
    package = mkPackageOption pkgs "glow" {};
    settings = mkOption {
      type = yamlFormat.type;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    wrappers.glow = {
      basePackage = cfg.package;
      prependFlags = [
        "--config"
        (yamlFormat.generate "glow.yml" cfg.settings)
      ];
    };
  };
}
