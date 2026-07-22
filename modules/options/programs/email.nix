{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.modules) mkIf;
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOptions'
    mkEnableOption
    literalExpression
    ;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  options.self.programs = {
    email = recursiveUpdate (mkEnableOptions' odprg.email.name) {
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
          if sys.video.enable then "thunderbird" else null
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

  config.self.programs = mkIf (dprg.email.name != null) {
    email.${dprg.email.name}.enable = true;
  };
}
