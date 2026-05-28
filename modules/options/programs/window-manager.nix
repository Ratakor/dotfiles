{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.modules) mkIf;
  inherit (lib.types) nullOr enum str;
  inherit (lib.attrsets) recursiveUpdate;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    windowManager = recursiveUpdate (mkEnableOptions' opt.default.windowManager.name) {
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
          if sys.video.enable then "niri" else null;
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

  config.self.programs = mkIf (cfg.default.windowManager.name != null) {
    windowManager.${cfg.default.windowManager.name}.enable = true;
  };
}
