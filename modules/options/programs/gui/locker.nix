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
    locker = mkEnableOptions' opt.default.locker.name;

    default.locker = {
      name = mkOption {
        type = enum [
          "dms"
          "glitchlock"
          "slock"
          "swaylock"
        ];
        default = if sys.displayServer == "wayland" then "dms" else "slock";
        description = "The default screen locker to use.";
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn the screen locker.";
      };
    };
  };

  config.self.programs = {
    locker.${cfg.default.locker.name}.enable = true;
    default.locker.cmd =
      if cfg.default.locker.name == "dms" then "dms ipc lock lock" else cfg.default.locker.name;
  };
}
