{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkPackageOption mkEnableOptions;
  inherit (lib.types) enum str;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
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

      # That should probably be removed in favor of `getExe package`
      cmd = mkOption {
        type = str;
        description = "The command to spawn the image viewer.";
      };

      # Should this be put in user.package here?
      package = mkPackageOption { } "default image viewer" { default = null; };
    };
  };

  config.self.programs = {
    imageViewer.${cfg.default.imageViewer.name}.enable = true;
  };
}
