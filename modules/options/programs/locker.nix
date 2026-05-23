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
    locker = mkEnableOptions' opt.default.locker.name;

    default.locker = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "glitchlock"
          "slock"
          "swaylock"
        ]);
        default =
          if sys.displayServer.wayland then
            "dms"
          else if sys.displayServer.x11 then
            "slock"
          else
            null;
        defaultText = literalMD ''
          `"dms"` if using Wayland, `"slock"` if using X11, `null` otherwise
        '';
        description = ''
          The default screen locker to use.
          This will automatically enable the corresponding program.
        '';
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn the screen locker.";
        # default = "dummy-locker";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.locker.name != null) {
    locker.${cfg.default.locker.name}.enable = mkDefault true;
    # TODO: This should be setup in modules/home/programs
    #       Also packages installation is probably all over the place
    default.locker.cmd =
      if cfg.default.locker.name == "dms" then "dms ipc lock lock" else cfg.default.locker.name;
  };
}
