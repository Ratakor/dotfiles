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
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.meta) getExe';

  cfg = config.wrap.services.librespot;
in {
  options.wrap.services.librespot = {
    enable = mkEnableOption "Librespot (Spotify Connect speaker daemon)";
    package = mkPackageOption pkgs "librespot" {};

    service.enable = mkEnableOption "Enable librespot as a user service";

    settings = mkOption {
      default = {};
    };

    wrapped = mkOption {
      type = types.package;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    wrap.services.librespot.wrapped = self.lib.wrapWith pkgs {
      basePackage = cfg.package;
      prependFlags =
        mapAttrsToList (
          k: v:
            if v == null || v == false
            then ""
            else if v == true
            then "--${k}"
            else "--${k}=${toString v}"
        )
        cfg.settings;
    };

    systemd.user.services = mkIf cfg.service.enable {
      librespot = {
        description = "Librespot (an open source Spotify client)";
        wantedBy = ["default.target"];

        serviceConfig = {
          ExecStart = getExe' cfg.wrapped "librespot";
          Restart = "always";
          RestartSec = 12;
        };
      };
    };
  };
}
