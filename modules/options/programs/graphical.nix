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

    imageViewer = {
      program = mkOption {
        type = enum [
          "imv"
          "nsxiv"
        ];
        default = if sys.displayServer == "wayland" then "imv" else "nsxiv";
        description = "The image viewer to use.";
      };

      cmd = mkOption {
        type = nullOr str;
        default = null;
        internal = true;
        description = "The image viewer command to use.";
      };

      desktopEntry = mkOption {
        type = nullOr str;
        default = null;
        internal = true;
        description = "The desktop entry of the image viewer.";
      };
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
