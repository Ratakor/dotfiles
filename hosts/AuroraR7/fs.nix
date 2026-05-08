{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/81668174-843e-4083-a2cb-1bc8b5ac3bf0";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/81668174-843e-4083-a2cb-1bc8b5ac3bf0";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/81668174-843e-4083-a2cb-1bc8b5ac3bf0";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime" # kinda important
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/5C77-BD85";
      fsType = "vfat";
      options = [
        # "noatime"
        "fmask=0022"
        "dmask=0022"
      ];
    };

    # "/ssd" = {
    #   device = "/dev/disk/by-uuid/278e43c9-34a9-402f-8033-d452814954fc";
    #   fsType = "btrfs";
    #   options = [
    #     "subvol=ssd"
    #     "compress=zstd"
    #     "noatime"
    #   ];
    # };

    "/storage" = {
      device = "/dev/disk/by-uuid/7646a9b2-9406-4ddb-ba96-062d93954acf";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        # "noatime"
      ];
    };
  };
}
