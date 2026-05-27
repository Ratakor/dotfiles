{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalMD;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum str;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    powerMenu = mkEnableOptions' opt.default.powerMenu.name;

    default.powerMenu = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
          "wlogout"
        ]);
        default = if sys.displayServer.wayland then "dms" else null;
        defaultText = literalMD ''
          `"dms"` if using Wayland, `null` otherwise
        '';
        description = ''
          The default power menu to use.
          This will automatically enable the corresponding program.
        '';
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn the default power menu.";
        # default = "dummy-power-menu";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.powerMenu.name != null) {
    powerMenu.${cfg.default.powerMenu.name}.enable = mkDefault true;
  };
}
