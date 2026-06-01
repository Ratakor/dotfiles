{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOptions';
  inherit (lib.modules) mkIf;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    imageEditor = mkEnableOptions' opt.default.imageEditor.name;

    # TODO: currently unused beside for generating imageEditor options
    default.imageEditor = {
      name = mkOption {
        type = nullOr (enum [
          "aseprite" # pixel art editor
          "drawy"
          "gimp"
          "krita"
          "pinta"
        ]);
        default = null;
        description = ''
          The default image editor to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config.self.programs = mkIf (cfg.default.imageEditor.name != null) {
    imageEditor.${cfg.default.imageEditor.name}.enable = true;
  };
}
