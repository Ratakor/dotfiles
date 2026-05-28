{
  fileSystems = {
    "/" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
        "noatime"
      ];
    };

    "/var" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [
        "subvol=@var"
        "compress=zstd"
        "noatime"
      ];
      neededForBoot = true; # to have a correct log order
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7384-BE02";
      fsType = "vfat";
      options = [
        # "noatime"
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}
