{
  # See big comment in modules/nixos/fs/zfs.nix for zpool options
  # dedup=on autotrim=off

  # TODO: move this to notes or disko or idk but please this line is too long,
  # also where is the quick install guide for the rest of the partitions
  # Create a reserved partition with 10% of the total disk capacity
  # zfs create -o refreservation=$(printf '%s * 0.1' "$(zpool get size -pj | jq -r .pools.zpool.properties.size.value)" | bc | numfmt --to=iec) -o mountpoint=none zpool/reserved

  fileSystems = {
    "/" = {
      device = "zpool/root";
      fsType = "zfs";
      # The zfsutil option is needed when mounting ZFS datasets without legacy mountpoints
      # option = [ "zfsutil" ];
    };

    "/nix" = {
      device = "zpool/nix";
      fsType = "zfs";
    };

    "/var" = {
      device = "zpool/var";
      fsType = "zfs";
    };

    "/home" = {
      device = "zpool/home";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8224-B0EA";
      fsType = "vfat";
      options = [
        "noatime"
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/279e9b8b-02";
      randomEncryption = {
        enable = true;
        cipher = "serpent-xts-plain64";
        keySize = 512;
      };
    }
  ];

  # TODO: disko
  # https://git.disroot.org/folliehiyuki/nixconfig/src/branch/main/flake/nixos/aragorn/hardware.nix
  # https://github.com/nix-community/disko/blob/master/example/zfs.nix
  # disko.devices = {
  #   nodev."/" = {
  #     fsType = "tmpfs";
  #     mountOptions = [
  #       "defaults"
  #       "size=1G"
  #       "mode=755"
  #     ];
  #   };

  #   disk.sda = {
  #     device = "/dev/sda";
  #     # device = "/dev/disk/by-id/..."
  #     type = "disk";
  #     content = {
  #       type = "gpt"; # "msdos"?
  #     };
  #   };
  # };
}
