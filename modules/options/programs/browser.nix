{
  config,
  lib,
  options,
  pkgs,
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
        package = mkPackageOption pkgs "chromium" {
          default = "helium";
          example = [ "ungoogled-chromium" ]; # see also cromite, github:celenityy/titanium
        };
      };

      firefox = {
        package = mkPackageOption pkgs "firefox" {
          example = [ "librewolf" ]; # see also github:celenityy/phoenix
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

      package =
        (mkPackageOption { } "default browser" {
          nullable = true;
          default = null;
        })
        // {
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
