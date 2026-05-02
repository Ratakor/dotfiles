# This should probably be in services not programs.
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions';
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    statusBar = mkEnableOptions' opt.default.statusBar.name;

    default.statusBar = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "sb"
          "waybar"
        ]);
        default =
          if sys.displayServer.wayland then
            "dms"
          else if sys.displayServer.x11 then
            "sb"
          else
            null;
        description = "The default status bar to use.";
      };
    };
  };

  config.self.programs = mkIf (cfg.default.statusBar.name != null) {
    statusBar.${cfg.default.statusBar.name}.enable = mkDefault true;
  };
}
