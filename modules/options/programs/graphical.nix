{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str nullOr;

  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    windowManager = mkOption {
      type = nullOr (enum [
        "dwm"
        "hyprland"
        "niri"
        "river" # not implemented
        "river-classic"
      ]);
      default = if sys.displayServer == "wayland" then "niri" else "dwm";
      description = "The window manager to use.";
    };

    locker = {
      program = mkOption {
        type = enum [
          "dms"
          "glitchlock"
          "slock"
          "swaylock"
        ];
        default = if sys.displayServer == "wayland" then "dms" else "slock";
        description = "The screen locker to use.";
      };

      cmd = mkOption {
        type = str;
        default = if cfg.locker.program == "dms" then "dms ipc lock lock" else cfg.locker.program;
        internal = true;
        readOnly = true;
        description = "The screen locker command to use.";
      };
    };
  };
}
