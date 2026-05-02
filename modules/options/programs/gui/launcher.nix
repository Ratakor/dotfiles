# see also: dms, anyrun, walker
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

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    launcher = mkEnableOptions' opt.default.launcher.name;

    default.launcher = {
      name = mkOption {
        type = nullOr (enum [
          "dmenu"
          "fuzzel"
          "tofi"
          "vicinae"
        ]);
        default =
          if sys.displayServer.wayland then
            "fuzzel"
          else if sys.displayServer.x11 then
            "dmenu"
          else
            null;
        description = "The default launcher to use.";
      };

      dmenu = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu like dmenu.";
        # default = "dummy-launcher";
      };

      drun = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from desktop files.";
        # default = "dummy-launcher";
      };

      run = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from $PATH.";
        # default = "dummy-launcher";
      };
    };
  };

  config.self.programs = mkIf (cfg.default.launcher.name != null) {
    launcher.${cfg.default.launcher.name}.enable = mkDefault true;
  };
}
