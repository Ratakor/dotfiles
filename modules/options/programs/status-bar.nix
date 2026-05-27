# This should probably be in services not programs.
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalMD;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum str;

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
          "noctalia"
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
        defaultText = literalMD ''
          `"dms"` if using Wayland, `"sb"` if using X11, `null` otherwise
        '';
        description = ''
          The default status bar to use.
          This will automatically enable the corresponding program.
        '';
      };

      toggle = mkOption {
        type = str;
        description = "The command to toggle the default status bar.";
        # default = "dummy-status-bar";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.statusBar.name != null) {
    statusBar.${cfg.default.statusBar.name}.enable = mkDefault true;
  };
}
