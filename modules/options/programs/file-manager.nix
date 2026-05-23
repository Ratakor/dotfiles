{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions;
  inherit (lib.modules) mkDefault;
  inherit (lib.types) enum str;
  inherit (lib.attrsets) recursiveUpdate;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    fileManager = recursiveUpdate (mkEnableOptions opt.default.fileManager.name) {
      yazi.enable.default = true;
    };

    default.fileManager = {
      name = mkOption {
        type = enum [
          "terminal" # directly use the terminal
          "yazi" # terminal file manager
          "nautilus" # gnome
          "dolphin" # kde
        ];
        default = "terminal";
        description = ''
          The default file manager to use.
          This will automatically enable the corresponding program.
        '';
      };

      desktopEntry = mkOption {
        type = str;
        description = "The desktop entry of the default file manager.";
        internal = true;
      };
    };
  };

  config.self.programs = {
    fileManager.${cfg.default.fileManager.name}.enable = mkDefault true;
  };
}
