{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.self.system.security.apparmor;
in
{
  config = lib.mkIf cfg.enable {
    services.dbus.apparmor = "enabled";

    environment.systemPackages = with pkgs; [
      apparmor-pam
      apparmor-utils
      apparmor-parser
      apparmor-profiles
      apparmor-bin-utils
      apparmor-kernel-patches
      libapparmor
    ];

    security.apparmor = {
      enable = true;
      packages = [ pkgs.apparmor-profiles ];

      # Whether to enable caching of AppArmor policies in /var/cache/apparmor.
      # This will probably increase build time
      enableCache = true;

      # Whether to kill porceses which have an AppArmor profile enabled
      # but are not confined. (SIGTERM)
      killUnconfinedConfinables = true;

      # TODO: this is the important part and it's actually not configured :)
      policies = {
        "default_deny" = {
          enforce = false;
          enable = false;
          profile = ''
            profile default_deny /** { }
          '';

          "sudo" = {
            enforce = false;
            enable = false;
            profile = ''
              ${lib.getExe config.security.sudo.package} {
                file /** rwlkUx,
              }
            '';
          };

          "nix" = {
            enforce = false;
            enable = false;
            profile = ''
              ${lib.getExe config.nix.package} {
                unconfined,
              }
            '';
          };
        };
      };
    };
  };
}
