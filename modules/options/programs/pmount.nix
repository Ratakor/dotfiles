{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe';

  cfg = config.programs.pmount;

  mkSetuidWrapper = package: command: {
    setuid = true;
    owner = "root";
    group = "root";
    source = getExe' package command;
  };
in
{
  options.programs.pmount = {
    enable = mkEnableOption "pmount (policy mount)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pmount ];

    security.wrappers = {
      pmount = mkSetuidWrapper pkgs.pmount "pmount";
      pumount = mkSetuidWrapper pkgs.pmount "pumount";
    };

    systemd.tmpfiles.rules = [
      "d /media 0755 root root"
    ];
  };
}
