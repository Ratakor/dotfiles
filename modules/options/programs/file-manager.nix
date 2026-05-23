{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) enum;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    fileManager = mkEnableOptions opt.default.fileManager.name;

    default.fileManager = {
      name = mkOption {
        type = enum [
          "yazi" # terminal file manager
          "nautilus" # gnome
          "dolphin" # kde
        ];
        default = "yazi";
        description = ''
          The default file manager to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config.self.programs = mkIf (cfg.default.fileManager.name != null) {
    fileManager.${cfg.default.fileManager.name}.enable = mkDefault true;
  };
}
