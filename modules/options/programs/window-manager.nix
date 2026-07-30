{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram mkOption literalExpression;
  inherit (lib) types;
in
mkVideoProgram config "window manager" {
  values = [
    "hyprland"
    "niri"
    # "river"
    "river-classic"
  ];
  default = "niri";
  commands = {
    cmd = "spawn a new window manager session from TTY";
  };
  extraDefaultOptions = {
    session = mkOption {
      type = types.str;
      description = "The name of the default window manager session.";
      # default = "dummy-window-manager";
      internal = true;
    };
  };
  extraOptions = {
    niri = {
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = ''
          Extra config to include into niri configuration.
          This will override conflicting prior options.
        '';
      };
    };

    river-classic = {
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = ''
          Extra config to include into river-classic configuration.
        '';
      };
    };

    binds = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            spawn = mkOption {
              type = types.str;
              description = "Command to execute";
            };
            # TODO: useful on river and also on niri since there are a lot of
            # duplicate repeat=false, could also add a type to niri option
            #repeat = mkOption {
            #  type = types.bool;
            #  default = false;
            #  description = "";
            #};
            niri = mkOption {
              type = types.attrs;
              default = { };
              description = "Additional args to be used by niri.";
            };
          };
        }
      );
      default = { }; # see /nixos/modules/nixos/programs/window-manager/binds.nix
      example = literalExpression ''
        {
          "Mod+Return" = {
            spawn = dprg.terminal.cmd;
            niri = {
              repeat = false;
              hotkey-overlay-title = "Open a terminal: ''${dprg.terminal.name}";
            };
          };
        }
      '';
      description = "Keybinds shared across all window managers.";
    };
  };
}
