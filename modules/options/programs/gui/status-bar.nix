# This should probably be in services not programs.
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions;
  inherit (lib.types) enum;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    statusBar = mkEnableOptions opt.default.statusBar.name;

    default.statusBar = {
      name = mkOption {
        type = enum [
          "dms"
          "sb"
          "waybar"
        ];
        default = if sys.displayServer.wayland then "dms" else "sb";
        description = "The default status bar to use.";
      };
    };
  };

  config.self.programs = {
    statusBar.${cfg.default.statusBar.name}.enable = true;
  };
}
