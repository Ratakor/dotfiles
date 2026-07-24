{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib) types;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    windowManager = recursiveUpdate (mkEnableOptions' odprg.windowManager.name) {
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

    default.windowManager = {
      name = mkOption {
        type = types.nullOr (
          types.enum [
            "hyprland"
            "niri"
            # "river"
            "river-classic"
          ]
        );
        default = if sys.video.enable then "niri" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "niri" else null
        '';
        description = ''
          The default window manager to use.
          This will automatically enable the corresponding program.
        '';
      };

      cmd = mkOption {
        type = types.str;
        description = "The command to spawn a new window manager session from TTY.";
        # default = "dummy-window-manager"; # probably a bad idea
        internal = true;
      };

      session = mkOption {
        type = types.str;
        description = "The name of the default window manager session.";
        # default = "dummy-window-manager";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (dprg.windowManager.name != null) {
    windowManager.${dprg.windowManager.name}.enable = true;
  };
}
