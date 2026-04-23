{
  imports = [
    # hardware-configuration.nix should probably be merged here or sorted e.g.
    # filesystem.nix with all zfs stuff, etc...
    ./hardware-configuration.nix
  ];

  self = {
    colors = {
      theme = "gruvbox";
      variant = "dark";
    };

    system = {
      displayServer.wayland = true;
      audio.enable = true;
      video.enable = true;
      bluetooth.enable = false;
      virt = {
        podman.enable = true;
      };
      boot = {
        loader.grub = {
          enable = true;
          device = "/dev/sda";
        };
      };
    };
  };

  # weird bug can't boot on index 0 iirc
  boot.loader.grub.default = 1;

  services.zfs = {
    autoReplication = {
      enable = false;
    };

    autoScrub = {
      enable = true;
      pools = [ "zpool" ];
      interval = "monthly";
    };

    # Enable the (OpenSolaris-compatible) ZFS auto-snapshotting service.
    # Note that you must set the ‘com.sun:auto-snapshot’ property to
    # ‘true’ on all datasets which you wish to auto-snapshot.
    #
    # You can override a child dataset to use, or not use
    # auto-snapshotting by setting its flag with the given interval: ‘zfs
    # set com.sun:auto-snapshot:weekly=false DATASET’
    autoSnapshot = {
      enable = true;
      frequent = 8; # number of 15min snapshot to keep (default 4)
      hourly = 24; # number of hourly snapshot to keep (default 24)
      daily = 7; # number of daily snapshot to keep (default 7)
      weekly = 4; # number of weekly snapshot to keep (default 4)
      monthly = 12; # number of monthly snapshot to keep (default 12)
    };

    trim = {
      enable = true;
      interval = "weekly";
    };
  };
}
