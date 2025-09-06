{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;

  yaml = pkgs.formats.yaml {};

  cfg = config.programs.glow;
in {
  options.programs.glow = {
    enable = mkEnableOption "Glow";
    package = mkPackageOption pkgs "glow" {};
    settings = mkOption {
      type = yaml.type;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    wrappers.glow = {
      basePackage = cfg.package;
      prependFlags = [
        "--config"
        (yaml.generate "glow.yml" cfg.settings)
      ];
    };
  };
}
