{ config, lib, ... }:
{
  config = lib.mkIf config.boot.zfs.enabled {
    services = {
      zfs = {
        # Automatic transfer of ZFS snapshots to a remote location.
        autoReplication = {
          enable = false;
        };

        autoScrub = {
          enable = true;
          pools = [ ]; # Leave empty to scrub all pools
          interval = "monthly"; # default: monthly
        };

        # Enable the (OpenSolaris-compatible) ZFS auto-snapshotting service.
        # Note that you must set the `com.sun:auto-snapshot` property to
        # `true` on all datasets which you wish to auto-snapshot.
        #
        # You can override a child dataset to use, or not use
        # auto-snapshotting by setting its flag with the given interval:
        # `zfs set com.sun:auto-snapshot:weekly=false DATASET`
        #
        # See also services.sanoid.
        autoSnapshot = {
          enable = true;
          flags = "-k -p -u"; # default: "-k -p", -u is recommended
          frequent = 8; # Number of 15min snapshot to keep (default 4)
          hourly = 24; # Number of hourly snapshot to keep (default 24)
          daily = 7; # Number of daily snapshot to keep (default 7)
          weekly = 4; # Number of weekly snapshot to keep (default 4)
          monthly = 12; # Number of monthly snapshot to keep (default 12)
        };

        trim = {
          enable = true;
          interval = "weekly"; # default: weekly
        };
      };
    };
  };
}
