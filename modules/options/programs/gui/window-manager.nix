{
  config,
  lib,
  options,
  self,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str;
  inherit (self.lib.options) mkEnableOptions;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    windowManager = mkEnableOptions opt.default.windowManager.name;

    default.windowManager = {
      name = mkOption {
        type = enum [
          "dwm"
          "hyprland"
          "niri"
          # "river"
          "river-classic"
        ];
        default = if sys.displayServer.wayland then "niri" else "dwm";
        description = "The default window manager to use.";
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn a new window manager session from TTY.";
      };
    };
  };

  config.self.programs = {
    windowManager.${cfg.default.windowManager.name}.enable = true;
  };
}
