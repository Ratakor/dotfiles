# TODO: doesn't work yet
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) escapeShellArgs;
  inherit (lib.meta) getExe;

  cfg = config.programs.eza;
in {
  options.programs.eza = {
    enable = mkEnableOption "eza, a modern replacement for {command}`ls`";

    package = mkPackageOption pkgs "eza" {};

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
    # TODO: that should be something like home idk
    users.users.ratakor.packages = let
      wrapper = pkgs.writeShellScriptBin "eza" ''
        exec "${getExe cfg.package}" ${escapeShellArgs cfg.args} "$@"
      '';
    in [wrapper];
  };
}
