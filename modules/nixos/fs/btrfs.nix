{ config, lib, ... }:
let
  # stolen from https://git.darmstadt.ccc.de/piegames/home-config/-/blob/master/machines/prismarine/snapper.nix
  # this needs tuning
  mkSnapperConfig = subvolume: {
    SUBVOLUME = subvolume; # subvolume to snapshot
    FSTYPE = "btrfs"; # filesystem type
    QGROUP = ""; # btrfs qgroup for space aware cleanup algorithms
    SPACE_LIMIT = "0.5"; # fraction of the filesystems space the snapshots may use
    FREE_LIMIT = "0.2"; # fraction of the filesystems space that should be free

    # users and groups allowed to work with config
    ALLOW_USERS = [ ];
    ALLOW_GROUPS = [ ];
    # sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots directory
    SYNC_ACL = false;

    BACKGROUND_COMPARISON = true; # start comparing pre- and post-snapshot in background after creating post-snapshot

    # Number cleanup
    NUMBER_CLEANUP = true; # enable
    NUMBER_MIN_AGE = 1800;
    NUMBER_LIMIT = 10;
    NUMBER_LIMIT_IMPORTANT = 5;

    TIMELINE_CREATE = true; # Create hourly snapshots
    TIMELINE_CLEANUP = true; # Cleanup hourly snapshots after some time

    # limits for timeline cleanup
    TIMELINE_MIN_AGE = 1800;
    TIMELINE_LIMIT_HOURLY = 5;
    TIMELINE_LIMIT_DAILY = 1;
    TIMELINE_LIMIT_WEEKLY = 0;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;

    EMPTY_PRE_POST_CLEANUP = true; # cleanup empty pre-post-pairs
    EMPTY_PRE_POST_MIN_AGE = 1800; # limits for empty pre-post-pair cleanup
  };
in
{
  config = lib.mkIf config.boot.supportedFilesystems.btrfs {
    services = {
      btrfs.autoScrub = {
        enable = true;
        # fileSystems = [ "/" ]; # let nixos figure it out
        interval = "monthly"; # default: monthly
      };

      snapper = {
        snapshotInterval = "*:0/15"; # every 15 minutes
        # A config with `root` name is mandatory but I think subvolume can be anything.
        configs = builtins.mapAttrs (lib.const mkSnapperConfig) {
          root = "/";
          home = "/home";
          # var = "/var";
        };
      };
    };
  };
}
