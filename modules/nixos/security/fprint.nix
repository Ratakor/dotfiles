{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.system.security.fprintd;
in
{
  config = mkIf cfg.enable {
    services.fprintd = {
      enable = true;
      tod = {
        enable = false; # ?
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    security.pam.services = {
      login.fprintAuth = true;
      swaylock.fprintAuth = true;
    };
  };
}
