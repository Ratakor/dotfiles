{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options)
    mkOption
    mkEnableOptions'
    literalExpression
    mkCommandOption
    ;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  options.self.programs = {
    wallpaper = mkEnableOptions' odprg.wallpaper.name;

    default.wallpaper = {
      name = mkOption {
        type = nullOr (enum [
          # "awww" # TODO
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

      nextRandom = mkCommandOption "switch to the next random wallpaper";
      set = mkCommandOption "set a wallpaper via a given path";
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
