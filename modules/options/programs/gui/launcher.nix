# see also: dms, anyrun, walker
{
  config,
  lib,
  options,
  self,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str;
  inherit (self.lib.options) mkEnableOptions';

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    launcher = mkEnableOptions' opt.default.launcher.name;

    default.launcher = {
      name = mkOption {
        type = enum [
          "dmenu"
          "tofi"
          "fuzzel"
          "vicinae"
        ];
        default = if sys.displayServer == "wayland" then "fuzzel" else "dmenu";
        description = "The default launcher to use.";
      };

      dmenu = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu like dmenu.";
      };

      drun = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from desktop files.";
      };

      run = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from $PATH.";
      };
    };
  };

  config.self.programs = {
    launcher.${cfg.default.launcher.name}.enable = true;
  };
}
