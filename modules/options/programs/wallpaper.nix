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

  opt = options.self.programs;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  options.self.programs = {
    wallpaper = mkEnableOptions' opt.default.wallpaper.name;

    default.wallpaper = {
      name = mkOption {
        type = nullOr (enum [
          "dms"
          "noctalia"
          "randwp" # backed by swaybg
          "wpaperd"
        ]);
        default = dprg.desktopShell.name;
        defaultText = literalExpression ''
          dprg.desktopShell.name
        '';
        description = ''
          The default wallpaper utility to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.desktopShell.name instead.
        '';
      };

      nextRandom = mkOption {
        type = str;
        description = "The command to switch to the next random wallpaper.";
        # default = "dummy-wallpaper";
        internal = true;
      };

      # TODO: use in plumber (--dmenu so not that important)
      set = mkOption {
        type = str;
        description = "The command to set a wallpaper via a given path.";
        # default = "dummy-wallpaper";
        internal = true;
      };
    };
  };

  config = mkIf (dprg.wallpaper.name != null) {
    assertions = [
      {
        assertion =
          prg.desktopShell ? ${dprg.wallpaper.name} -> prg.desktopShell.${dprg.wallpaper.name}.enable;
        message = "The corresponding desktop shell must be enabled for wallpaper utility.";
      }
    ];

    self.programs.wallpaper.${dprg.wallpaper.name}.enable = true;
  };
}
