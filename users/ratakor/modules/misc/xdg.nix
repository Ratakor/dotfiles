{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.xdg;
in {
  options.xdg = {
    cache = mkOption {
      type = path;
      default = "${cfg.directory}/.cache";
    }
  };
}
