{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.system.virt.qemu;
in
{
  config = mkIf cfg.enable {
    virtualisation = {
      # Allows to share Intel integrated graphics card with KVM.
      # Requires users to have "kvm" group.
      kvmgt.enable = true;

      # Allows uprivileged users to pass USB device to libvirtd VMs.
      spiceUSBRedirection.enable = false; # default: false

      # Requires users to have "libvirtd" group.
      libvirtd = {
        enable = true;
        qemu = {
          inherit (cfg) package;
          runAsRoot = false;
          swtpm.enable = true;
        };
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    # Trust bridge network interface(s)
    networking.firewall.trustedInterfaces = [
      "virbr0"
      "br0"
    ];

    # Additional kernel modules that may be needed by libvirt
    boot.kernelModules = [ "vfio-pci" ];

    # For passthrough with VFIO
    services.udev.extraRules = ''
      # Supporting VFIO
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    programs.virt-manager.enable = true;
    # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752/2
    # add virtiofsd to filesystem xml
    # <binary path="/run/current-system/sw/bin/virtiofsd"/>
    environment.systemPackages = [ pkgs.virtiofsd ];
  };
}
