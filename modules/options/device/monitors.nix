{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) types;
in
{
  # stole this beauty from iynaix
  options.self.device.monitors = mkOption {
    description = "A list of monitors connected to the system.";
    default = [ ];
    type = types.listOf (
      types.submodule (
        { config, ... }:
        {
          options = {
            enable = mkEnableOption "this monitor" // {
              default = true;
            };
            name = mkOption {
              type = types.str;
              description = "The name of the monitor, e.g. eDP-1.";
            };
            width = mkOption {
              type = types.int;
              description = "Pixel width of the monitor.";
            };
            height = mkOption {
              type = types.int;
              description = "Pixel width of the monitor.";
            };
            refreshRate = mkOption {
              type = types.nullOr types.str; # str because niri wants exacts numbers
              default = null;
              description = ''
                Refresh rate of the monitor.
                Use null for the default refresh rate.
              '';
            };
            variableRefreshRate = mkEnableOption "Variable Refresh Rate";
            x = mkOption {
              type = types.int;
              default = 0;
              description = "Position x coordinate of the monitor.";
            };
            y = mkOption {
              type = types.int;
              default = 0;
              description = "Position y coordinate of the monitor.";
            };
            scale = mkOption {
              type = types.float;
              default = 1.0;
              description = "Scale of the monitor.";
            };
            transform = mkOption {
              # Yes for niri this doesn't make sense and it could be an enum
              # but for compatibility with hyprland it's easier this way.
              type = types.ints.between 0 7;
              default = 0;
              description = ''
                Rotate the output counter-clockwise.

                0 -> normal (no transforms)
                1 -> 90 degrees
                2 -> 180 degrees
                3 -> 270 degrees
                4 -> flipped
                5 -> flipped + 90 degrees
                6 -> flipped + 180 degrees
                7 -> flipped + 270 degrees
              '';
            };
            isVertical = mkOption {
              type = types.bool;
              default = (lib.mod config.transform 2) == 1;
              defaultText = lib.literalExpression "(lib.mod config.transform 2) == 1";
              description = "Whether the monitor is vertical.";
              readOnly = true;
            };
            # hdr = mkEnableOption "HDR";
            # workspaces = mkOption {
            #   type = types.nonEmptyListOf types.int;
            #   description = "List of workspace numbers.";
            #   # default = [1 2 3 4 5 6 7 8 9 10];
            # };
            # defaultWorkspace = mkOption {
            #   type = types.enum config.workspaces;
            #   default = builtins.elemAt config.workspaces 0;
            #   description = "Default workspace for this monitor.";
            # };
          };
        }
      )
    );
  };
}
