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
    mkEnableOption
    literalMD
    ;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum str;
  inherit (lib.attrsets) recursiveUpdate;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    browser = recursiveUpdate (mkEnableOptions' opt.default.browser.name) {
      chromium = {
        # this could be a package option instead
        ungoogled = mkEnableOption "ungoogled chromium patches" // {
          default = true;
        };
      };
    };

    default.browser = {
      name = mkOption {
        type = nullOr (enum [
          "chromium"
          "firefox"
          "nyxt"
          "qutebrowser"
          "tor-browser"
        ]);
        default = if sys.displayServer.wayland || sys.displayServer.x11 then "chromium" else null;
        defaultText = literalMD ''
          `"chromium"` if using Wayland or X11, `null` otherwise
        '';
        description = ''
          The default browser to use.
          This will automatically enable the corresponding program.
        '';
      };

      package = (mkPackageOption { } "default browser" { default = null; }) // {
        internal = true;
      };

      newWindow = mkOption {
        type = str;
        description = "The command to spawn a new window.";
        # default = "dummy-browser --new-window";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.browser.name != null) {
    browser.${cfg.default.browser.name}.enable = mkDefault true;
  };
}
