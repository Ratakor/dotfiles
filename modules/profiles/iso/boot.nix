{ pkgs, ... }:
{
  boot = {
    # Make the installer more likely to succeed in low memory
    # environments.  The kernel's overcommit heustistics bite us
    # fairly often, preventing processes such as nix-worker or
    # download-using-manifests.pl from forking even if there is
    # plenty of free memory.
    kernel.sysctl."vm.overcommit_memory" = "1";

    loader = {
      grub.memtest86.enable = true;
      systemd-boot.enable = false;
    };

    supportedFilesystems = [
      # "ext2"
      # "ext3"
      "ext4"
      "btrfs"
      # "cifs"
      # "f2fs"
      "ntfs"
      "vfat"
      "xfs"
      "zfs"
    ];

    swraid = {
      # idk but anyway you should be using zfs
      enable = false;
      # remove warning about unset mail
      mdadmConf = "PROGRAM ${pkgs.coreutils}/bin/true";
    };

    postBootCommands = ''
      # Provide a mount point for nixos-install.
      mkdir -p /mnt
    '';
  };
}
