{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) escapeShellArgs;
  inherit (lib.meta) getExe;

  cfg = config.services.librespot;
in {
  # TODO: since it's a service add it to systemd services
  options.services.librespot = {
    enable = mkEnableOption "Librespot Spotify client";

    package = mkPackageOption pkgs "librespot" {};

    settings = mkOption {
      # TODO: type, example, description
      default = {};
    };

    args = mkOption {
      readOnly = true;
      default =
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
  };

  config = mkIf cfg.enable {
    users.users.ratakor.packages = let
      wrapper = pkgs.writeShellScriptBin "librespot" ''
        exec ${getExe cfg.package} ${escapeShellArgs cfg.args} "$@"
      '';
    in [wrapper]; # TODO: other outputs? e.g. cfg.package.man
  };
}
