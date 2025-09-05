{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals;

  cfg = config.programs.zellij;
in {
  options.programs.zellij = {
    enable = mkEnableOption "Zellij";
    package = mkPackageOption pkgs "zellij" {};
    config = mkOption {
      type = types.nullOr types.path;
      description = "Path to zellij config file.";
    };
    # theme = mkOption {
    #   type = types.nullOr types.str;
    #   description = "Set the zellij theme.";
    # };
  };

  config = mkIf cfg.enable {
    wrappers.zellij = {
      basePackage = cfg.package;
      prependFlags = optionals (cfg.config != null) [
        "--config"
        cfg.config
      ];
    };
  };
}
