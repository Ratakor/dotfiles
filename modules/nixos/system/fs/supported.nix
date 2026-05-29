let
  supportedFilesystems = [
    "btrfs"
    "ext4"
    "ntfs"
    "vfat"
    "xfs"
    "zfs"
  ];
in
{
  boot = {
    inherit supportedFilesystems;
    initrd = {
      # inherit supportedFilesystems;
    };
  };
}
