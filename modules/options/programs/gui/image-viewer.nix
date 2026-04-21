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
    imageViewer = mkEnableOptions' opt.default.imageViewer.name;

    default.imageViewer = {
      name = mkOption {
        type = enum [
          "imv"
          "nsxiv"
        ];
        default = if sys.displayServer.wayland then "imv" else "nsxiv";
        description = "The default image viewer to use.";
      };

      cmd = mkOption {
        type = str;
        description = "The command to spawn the image viewer.";
      };

      desktopEntry = mkOption {
        type = str;
        description = "The desktop entry of the image viewer.";
      };
    };
  };

  config.self.programs = {
    imageViewer.${cfg.default.imageViewer.name}.enable = true;
  };
}
