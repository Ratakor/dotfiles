{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) enum;
in
{
  options.self.system.security.selinux = {
    enable = mkEnableOption "system SELinux support";
    state = mkOption {
      type = enum [
        "enforcing"
        "permissive"
        "disabled"
      ];
      default = "enforcing";
      description = ''
        The state of SELinux on the system.

        enforcing - SELinux security policy is enforced.
                    Set this value once you know for sure that SELinux is configured the way you like it and that your system is ready for deployment
        permissive - SELinux prints warnings instead of enforcing.
                     Use this to customise your SELinux policies and booleans prior to deployment. Recommended during policy development.
        disabled - No SELinux policy is loaded.
                   This is not a recommended setting, for it may cause problems with file labelling
      '';
    };
  };
}
