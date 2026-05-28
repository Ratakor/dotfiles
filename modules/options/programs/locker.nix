{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalExpression;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum str;

  opt = options.self.programs;
  prg = config.self.programs;
  dprg = prg.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    locker = mkEnableOptions' opt.default.locker.name;

    default.locker = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "glitchlock" # backed by swaylock
          "noctalia"
          "slock"
          "swaylock"
        ]);
        default = if sys.displayServer.x11 then "slock" else dprg.desktopShell.name;
        defaultText = literalExpression ''
          if sys.displayServer.x11 then "slock" else dprg.desktopShell.name;
        '';
        description = ''
          The default screen locker to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
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

  config = mkIf (dprg.locker.name != null) {
    assertions = [
      {
        assertion = prg.desktopShell ? ${dprg.locker.name} -> prg.desktopShell.${dprg.locker.name}.enable;
        message = "The corresponding desktop shell must be enabled for locker.";
      }
    ];

    self.programs = {
      locker.${dprg.locker.name}.enable = true;

      # TODO: This should be setup in modules/home/programs
      #       Also packages installation is probably all over the place
      default.locker.cmd = mkDefault dprg.locker.name;
    };
  };
}
