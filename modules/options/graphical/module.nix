{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str nullOr;

  cfg = config.self;
in
{
  # move to displayManager.wayland.enable?
  # replace profiles.graphical?
  options.self = {
    displayServer = mkOption {
      type = enum [
        "x11"
        "wayland"
      ];
      default = "wayland";
      description = "The display server to use.";
    };

    windowManager = mkOption {
      type = enum [
        "dwm"
        "river-classic"
        "river" # not implemented
        "niri"
        "hyprland"
      ];
      default = if cfg.displayServer == "wayland" then "niri" else "dwm";
      description = "The window manager to use.";
    };

    menu = {
      program = mkOption {
        type = enum [
          "dmenu"
          "tofi"
          "fuzzel"
        ];
        default = if cfg.displayServer == "wayland" then "fuzzel" else "dmenu";
        description = "The menu program to use.";
      };

      dynamic = mkOption {
        type = nullOr str;
        default = null;
        description = "A dynamic menu like dmenu.";
      };
      drun = mkOption {
        type = nullOr str;
        default = null;
        description = "A dynamic menu to use for launching applications from desktop files.";
      };
      run = mkOption {
        type = nullOr str;
        default = null;
        description = "A dynamic menu to use for launching applications from $PATH.";
      };
    };

    terminal = {
      program = mkOption {
        type = enum [
          "foot"
          "st"
          "ghostty"
        ];
        default = if cfg.displayServer == "wayland" then "foot" else "ghostty";
        description = "The terminal emulator to use.";
      };

      cmd = mkOption {
        type = nullOr str;
        default = null;
        description = "The terminal command to use.";
      };

      cmdDir = mkOption {
        type = nullOr str;
        default = null;
        description = "The command with which to open directories in the terminal.";
      };
    };

    imageViewer = {
      program = mkOption {
        type = enum [
          "imv"
          "nsxiv"
        ];
        default = if cfg.displayServer == "wayland" then "imv" else "nsxiv";
        description = "The image viewer to use.";
      };

      cmd = mkOption {
        type = nullOr str;
        default = null;
        description = "The image viewer command to use.";
      };

      desktopEntry = mkOption {
        type = nullOr str;
        default = null;
        description = "The desktop entry of the image viewer.";
      };
    };
  };

  config = {
    system.nixos.tags = [ cfg.displayServer ];
  };
}
