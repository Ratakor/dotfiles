{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkPackageOption mkEnableOptions;
  inherit (lib.types) enum;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    imageViewer = mkEnableOptions opt.default.imageViewer.name;

    default.imageViewer = {
      name = mkOption {
        type = enum [
          "imv"
          "nsxiv"
        ];
        default = "imv";
        description = "The default image viewer to use.";
      };

      package = mkPackageOption { } "default image viewer" { default = null; };
    };
  };

  config.self.programs = {
    imageViewer.${cfg.default.imageViewer.name}.enable = true;
  };
}
