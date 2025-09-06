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
  inherit (lib.meta) getExe';

  ini = pkgs.formats.ini {listsAsDuplicateKeys = true;};

  cfg = config.wrap.programs.foot;
in {
  options.wrap.programs.foot = {
    enable = mkEnableOption "Foot terminal";
    package = mkPackageOption pkgs "foot" {};

    server.enable = mkEnableOption "Foot terminal server";

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
    wrap.programs.foot.wrapped = self.lib.wrapWith pkgs {
      basePackage = cfg.package;
      prependFlags = [
        "--config"
        (ini.generate "foot.ini" cfg.settings)
      ];
      # Skip footclient wrapping as it can't take a --config argument
      programs.footclient = {};
    };

    systemd.user.services = mkIf cfg.server.enable {
      foot = {
        description = "Fast, lightweight and minimalistic Wayland terminal emulator.";
        documentation = ["man:foot(1)"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];

        serviceConfig = {
          ExecStart = "${getExe' cfg.wrapped "foot"} --server";
          Restart = "on-failure";
          OOMPolicy = "continue";
        };
      };
    };
  };
}
