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

  ini = pkgs.formats.ini {};

  cfg = config.wrap.programs.fuzzel;
in {
  options.wrap.programs.fuzzel = {
    enable = mkEnableOption "Fuzzel";
    package = mkPackageOption pkgs "fuzzel" {};

    settings = mkOption {
      type = ini.type;
      default = {};
    };

    wrapped = mkOption {
      type = types.package;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    wrap.programs.fuzzel.wrapped = self.lib.wrapWith pkgs {
      basePackage = cfg.package;
      prependFlags = [
        "--config"
        (ini.generate "fuzzel.ini" cfg.settings)
      ];
    };
  };
}
