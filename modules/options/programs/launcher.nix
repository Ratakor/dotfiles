# see also: anyrun, walker
{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions' literalMD;
  inherit (lib.modules) mkIf;
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
          # "dms" # doesn't support dmenu style
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
        defaultText = literalMD ''
          `"fuzzel"` if using Wayland, `"dmenu"` if using X11, `null` otherwise
        '';
        description = ''
          The default launcher to use.
          This will automatically enable the corresponding program.
        '';
      };

      dmenu = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu like dmenu.";
        # default = "dummy-launcher";
        internal = true;
      };

      drun = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from desktop files.";
        # default = "dummy-launcher";
        internal = true;
      };

      run = mkOption {
        type = str;
        description = "The command to spawn a dynamic menu used to launch applications from $PATH.";
        # default = "dummy-launcher";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.launcher.name != null) {
    launcher.${cfg.default.launcher.name}.enable = true;
  };
}
