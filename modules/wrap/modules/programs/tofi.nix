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
  inherit (lib.generators) toINIWithGlobalSection;

  cfg = config.wrap.programs.tofi;
in {
  options.wrap.programs.tofi = {
    enable = mkEnableOption "Tofi, a tiny dynamic menu for Wayland";
    package = mkPackageOption pkgs "tofi" {};

    settings = mkOption {
      type = with types; attrsOf (either (either str int) bool);
      default = {};
    };

    wrapped = mkOption {
      type = types.package;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    wrap.programs.tofi.wrapped = self.lib.wrapWith pkgs {
      basePackage = cfg.package;
      prependFlags = [
        "--config"
        (pkgs.writeText "tofi-config" (toINIWithGlobalSection {} {
          globalSection = cfg.settings;
        }))
      ];
    };
  };
}
