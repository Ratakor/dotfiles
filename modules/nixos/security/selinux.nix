# Consider using AppArmor instead as SELinux doesn't make much sense on NixOS
# https://wiki.nixos.org/wiki/SELinux_workgroup
# https://nixos.wiki/wiki/Workgroup:SELinux
# https://nixos.wiki/wiki/Talk:Workgroup:SELinux
# https://wiki.archlinux.org/title/SELinux
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;

  cfg = config.self.system.security.selinux;
in
{
  config = mkIf cfg.enable {
    # Build systemd with SE Linux support so it loads policy at boot and supports file labelling
    systemd.package = pkgs.systemd.override { withSelinux = true; };

    security = {
      # iirc SELinux conflicts with AppArmor.
      apparmor.enable = false;

      # https://wiki.archlinux.org/title/SELinux#Enable_SELinux_LSM
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/security/Kconfig#n268
      lsm = mkForce [
        "landlock"
        "lockdown"
        "yama"
        "integrity" # "loadpin" "safesetid"
        "selinux"
        "bpf"
      ];
    };

    boot = {
      kernelParams = [
        # "security=selinux" # deprecated by "lsm=" parameter
        "selinux=1"
      ];

      kernelPatches = [
        {
          name = "selinux-config";
          patch = null;
          extraConfig = ''
            SECURITY_SELINUX y
            SECURITY_SELINUX_BOOTPARAM n
            SECURITY_SELINUX_DEVELOP y
            SECURITY_SELINUX_AVC_STATS y
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
