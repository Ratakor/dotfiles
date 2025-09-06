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
  inherit (lib.lists) optionals;

  cfg = config.wrap.programs.zellij;
in {
  options.wrap.programs.zellij = {
    enable = mkEnableOption "Zellij";
    package = mkPackageOption pkgs "zellij" {};

    config = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to zellij config file.";
    };
    # theme = mkOption {
    #   type = types.nullOr types.str;
    # };

    wrapped = mkOption {
      type = types.package;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    wrap.programs.zellij.wrapped = self.lib.wrapWith pkgs {
      basePackage = cfg.package;
      prependFlags = optionals (cfg.config != null) [
        "--config"
        cfg.config
      ];
    };
  };
}
