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
        ];
        default = if cfg.displayServer == "wayland" then "foot" else "st";
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

    # TODO: currently unused
    # why? because nsxiv -a option
    # just make a wrapper? yes true I cba tho
    imageViewer = mkOption {
      type = enum [
        "imv"
        "nsxiv"
      ];
      default = if cfg.displayServer == "wayland" then "imv" else "nsxiv";
      description = "The image viewer to use.";
    };
  };

  config = {
    system.nixos.tags = [ cfg.displayServer ];
  };
}
