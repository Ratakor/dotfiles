{ config, lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) types;

  cfg = config.self.device;
in
{
  # should this be renamed hardware instead of device?
  # or merge with system
  # or split system into multiple modules
  # idk, it doesn't matter much anywa
  options.self.device = {
    ram = {
      size = mkOption {
        type = types.int;
        description = "Total size of the system RAM in bytes.";
      };
    };

    cpu = {
      type = mkOption {
        type = types.enum [ "intel" ];
        description = "The manufacturer of the primary system CPU.";
      };
    };

    gpu = {
      type = mkOption {
        type = types.nullOr (types.enum [ "nvidia" ]);
        default = null;
        description = "The manufacturer of the primary system GPU.";
      };
    };

    # stole this beauty from iynaix
    monitors = mkOption {
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
              # hdr = mkEnableOption "HDR";
              # transform = mkOption {
              #   type = types.int;
              #   description = "Transform for rotation.";
              #   default = 0;
              # };
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
              # isVertical = mkOption {
              #   type = types.bool;
              #   default = lib.mod config.transform 2 == 1;
              #   description = "Whether the monitor is vertical.";
              #   readOnly = true;
              # };
            };
          }
        )
      );
    };
  };
}
