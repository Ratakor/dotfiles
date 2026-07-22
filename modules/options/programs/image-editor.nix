{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOptions';
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
in
{
  options.self.programs = {
    imageEditor = mkEnableOptions' odprg.imageEditor.name;

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

  config.self.programs = mkIf (dprg.imageEditor.name != null) {
    imageEditor.${dprg.imageEditor.name}.enable = true;
  };
}
