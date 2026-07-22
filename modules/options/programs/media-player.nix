{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOptions'
    literalExpression
    ;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    mediaPlayer = mkEnableOptions' odprg.mediaPlayer.name;

    default.mediaPlayer = {
      name = mkOption {
        type = nullOr (enum [
          "mpv"
          "vlc"
        ]);
        default = if sys.video.enable then "mpv" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "mpv" else null
        '';
        description = ''
          The default media player to use.
          This will automatically enable the corresponding program.
        '';
      };

      package =
        (mkPackageOption { } "default media player" {
          nullable = true;
          default = null;
        })
        // {
          internal = true;
        };
    };
  };

  config.self.programs = mkIf (dprg.mediaPlayer.name != null) {
    mediaPlayer.${dprg.mediaPlayer.name}.enable = true;
  };
}
