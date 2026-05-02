{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions';
  inherit (lib.modules) mkIf mkDefault;
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
          "dwm"
          "hyprland"
          "niri"
          # "river"
          "river-classic"
        ]);
        default =
          if sys.displayServer.wayland then
            "niri"
          else if sys.displayServer.x11 then
            "dwm"
          else
            null;
        description = "The default window manager to use.";
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn a new window manager session from TTY.";
        # default = "dummy-window-manager"; # probably a bad idea
      };
    };
  };

  config.self.programs = mkIf (cfg.default.windowManager.name != null) {
    windowManager.${cfg.default.windowManager.name}.enable = mkDefault true;
  };
}
