# https://wiki.nixos.org/wiki/SELinux_workgroup
# https://nixos.wiki/wiki/Workgroup:SELinux
# https://wiki.archlinux.org/title/SELinux
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.self.system.security.selinux;
in
{
  config = lib.mkIf cfg.enable {
    # Build systemd with SE Linux support so it loads policy at boot and supports file labelling
    systemd.package = pkgs.systemd.override { withSelinux = true; };

    # iirc SELinux conflicts with AppArmor.
    security.apparmor.enable = false;

    boot = {
      # not sure if selinux=1 is necessary
      kernelParams = [
        "security=selinux"
        "selinux=1"
      ];

      kernelPatches = [
        {
          name = "selinux-config";
          patch = null;
          extraConfig = ''
            SECURITY_SELINUX y
            SECURITY_SELINUX_BOOTPARAM n
            SECURITY_SELINUX_DISABLE n
            SECURITY_SELINUX_DEVELOP y
            SECURITY_SELINUX_AVC_STATS y
            SECURITY_SELINUX_CHECKREQPROT_VALUE 0
            DEFAULT_SECURITY_SELINUX n
          '';
        }
      ];
    };

    environment = {
      # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
      systemPackages = [ pkgs.policycoreutils ];

      etc."selinux/config".text = ''
        SELINUX=${cfg.state}
        # SELINUXTYPE= takes the name of SELinux policy to
        # be used. Current options are:
        #       refpolicy (vanilla reference policy)
        #       <custompolicy> - Substitute <custompolicy> with the name of any custom policy you choose to load
        SELINUXTYPE=refpolicy
      '';
    };
  };
}
