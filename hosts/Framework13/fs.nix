{
  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/var" = {
      device = "rpool/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8266-0474";
      fsType = "vfat";
      options = [
        # "noatime"
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}
