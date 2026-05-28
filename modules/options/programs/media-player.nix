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
    literalExpression
    ;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    mediaPlayer = mkEnableOptions' opt.default.mediaPlayer.name;

    default.mediaPlayer = {
      name = mkOption {
        type = nullOr (enum [
          "mpv"
          "vlc"
        ]);
        default = if sys.video.enable then "mpv" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "mpv" else null;
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

  config.self.programs = mkIf (cfg.default.mediaPlayer.name != null) {
    mediaPlayer.${cfg.default.mediaPlayer.name}.enable = mkDefault true;
  };
}
