{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkImageMediaOverride;
in
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

    initrd.luks.devices = mkImageMediaOverride { };

    zfs.forceImportRoot = false;

    swraid = {
      # idk but anyway you should be using zfs
      enable = false;
      # remove warning about unset mail
      mdadmConf = "PROGRAM ${pkgs.coreutils}/bin/true";
    };
  };

  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = mkImageMediaOverride [ ];
  fileSystems = mkImageMediaOverride config.lib.isoFileSystems;

  # Prevent installation media from evacuating persistent storage, as their
  # var directory is not persistent and it would thus result in deletion of
  # those entries.
  # See: pstore.conf(5)
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';
}
