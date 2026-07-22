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
  inherit (lib.types) nullOr enum str;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    windowManager = recursiveUpdate (mkEnableOptions' odprg.windowManager.name) {
      niri = {
        extraConfig = mkOption {
          type = str;
          default = "";
          description = ''
            Extra config to include into niri configuration.
            This will override conflicting prior options.
          '';
        };
      };
      river-classic = {
        extraConfig = mkOption {
          type = str;
          default = "";
          description = ''
            Extra config to include into river-classic configuration.
          '';
        };
      };
    };

    default.windowManager = {
      name = mkOption {
        type = nullOr (enum [
          "hyprland"
          "niri"
          # "river"
          "river-classic"
        ]);
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
        type = str;
        description = "The command to spawn a new window manager session from TTY.";
        # default = "dummy-window-manager"; # probably a bad idea
        internal = true;
      };

      session = mkOption {
        type = str;
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
