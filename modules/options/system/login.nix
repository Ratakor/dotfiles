{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum;
in
{
  options.self.system.login = {
    autoLogin = mkEnableOption "automatic login";

    manager = mkOption {
      type = nullOr (enum [
        "dms-greeter"
        "gdm"
        "ly"
        "noctalia-greeter"
        "tuigreet"
      ]);
      default = null;
      description = ''
        The login manager to use.
        Setting this to `null` fallbacks to getty with optional auto login.
      '';
    };
  };
}
