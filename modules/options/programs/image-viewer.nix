{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOptions'
    literalMD
    ;
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
        defaultText = literalMD ''
          `"imv"` if using Wayland or X11, `null` otherwise
        '';
        description = ''
          The default image viewer to use.
          This will automatically enable the corresponding program.
        '';
      };

      package = (mkPackageOption { } "default image viewer" { default = null; }) // {
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.imageViewer.name != null) {
    imageViewer.${cfg.default.imageViewer.name}.enable = mkDefault true;
  };
}
