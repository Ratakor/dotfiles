{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkPackageOption mkEnableOptions';
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    imageViewer = mkEnableOptions' opt.default.imageViewer.name;

    default.imageViewer = {
      name = mkOption {
        type = nullOr (enum [
          "imv"
          "nsxiv"
        ]);
        default = if sys.displayServer.wayland || sys.displayServer.x11 then "imv" else null;
        description = "The default image viewer to use.";
      };

      package = mkPackageOption { } "default image viewer" { default = null; };
    };
  };

  config.self.programs = mkIf (cfg.default.imageViewer.name != null) {
    imageViewer.${cfg.default.imageViewer.name}.enable = mkDefault true;
  };
}
