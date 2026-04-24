{
  imports = [
    ./fstrim.nix
    ./lvm.nix
    ./zram.nix
  ];

  boot.supportedFilesystems = [
    # "btrfs"
    # "ext4"
    "ntfs"
    # "vfat"
    # "xfs"
    # "zfs"
  ];
}
