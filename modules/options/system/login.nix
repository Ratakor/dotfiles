{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum;
in
{
  options.self.system.login = {
    autoLogin = mkEnableOption "automatic login" // {
      default = true;
    };

    manager = mkOption {
      type = nullOr (enum [
        "gdm"
        "ly"
        "tuigreet"
      ]);
      default = "tuigreet";
      description = ''
        The login manager to use.
        Setting this to `null` fallbacks to getty with optional auto login.
      '';
    };
  };
}
