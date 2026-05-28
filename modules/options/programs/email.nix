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
    literalExpression
    ;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.types) nullOr enum;
  inherit (lib.attrsets) recursiveUpdate;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    email = recursiveUpdate (mkEnableOptions' opt.default.email.name) {
      thunderbird = {
        dove = mkEnableOption "privacy and security hardening Thunderbird using the Dove config" // {
          default = true;
        };
      };
    };

    default.email = {
      name = mkOption {
        type = nullOr (enum [
          "thunderbird"
        ]);
        default = if sys.video.enable then "thunderbird" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "thunderbird" else null;
        '';
        description = ''
          The default email client to use.
          This will automatically enable the corresponding program.
        '';
      };

      package =
        (mkPackageOption { } "default email client" {
          nullable = true;
          default = null;
        })
        // {
          internal = true;
        };
    };
  };

  config.self.programs = mkIf (cfg.default.email.name != null) {
    email.${cfg.default.email.name}.enable = mkDefault true;
  };
}
