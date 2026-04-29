{ config, lib, ... }:
let
  # See snapper-configs(5)
  mkSnapperConfig = path: {
    # Path of the subvolume or mount point.
    SUBVOLUME = path;
    # Filesystem type for the subvolume.
    FSTYPE = "btrfs";
    # The btrfs quoat group used for space aware cleanup algorithms.
    QGROUP = "";
    # Threshold for the maximum space snapshots should use on the filesystem.
    SPACE_LIMIT = "0.5"; # default: 0.5 (50%)
    # Threshold for the minimum free space that should remain on the filesystem.
    FREE_LIMIT = "0.2"; # default: 0.2 (20%)

    # List of users/groups allowed to operate with the config.
    ALLOW_USERS = [ config.user.name ];
    ALLOW_GROUPS = [ ];

    # Whether snapper will sync the users and groups from ALLOW_USERS and
    # ALLOW_GROUPS to the ACL of the .snapshots directory.
    SYNC_ACL = false;
    # Whether pre and post snapshots should be compared in the background after creation.
    BACKGROUND_COMPARISON = true;

    # Whether the number cleanup algorithm should be run for the config.
    NUMBER_CLEANUP = true;
    # Minimal age for snapshots to be deleted by the number cleanup algorithm.
    NUMBER_MIN_AGE = 3600; # default: 3600
    # Defines how many snapshots the number cleanup algorithm should keep.
    NUMBER_LIMIT = 25; # default: 50
    # Defines how many important snapshots the number cleanup algorithm should keep.
    NUMBER_LIMIT_IMPORTANT = 10; # default: 10

    # Whether hourly snapshots should be created.
    TIMELINE_CREATE = true;
    # Whether the timeline cleanup algorithm should be run for the config.
    TIMELINE_CLEANUP = true;
    # Minimal age for snapshots to be deleted by the timeline cleanup algorithm.
    TIMELINE_MIN_AGE = 3600; # default: 3600
    # Defines how many hourly snapshots the timeline cleanup algorithm should keep.
    TIMELINE_LIMIT_HOURLY = 24; # default: 10
    # Defines how many daily snapshots the timeline cleanup algorithm should keep.
    TIMELINE_LIMIT_DAILY = 7; # default: 10
    # Defines how many weekly snapshots the timeline cleanup algorithm should keep.
    TIMELINE_LIMIT_WEEKLY = 4; # default: 0
    # Defines how many monthly snapshots the timeline cleanup algorithm should keep.
    TIMELINE_LIMIT_MONTHLY = 12; # default: 10
    # Defines how many yearly snapshots the timeline cleanup algorithm should keep.
    TIMELINE_LIMIT_YEARLY = 0; # default: 10

    # Defines whether the empty-pre-post cleanup algorithm should be run for the config.
    EMPTY_PRE_POST_CLEANUP = true;
    # Minimal age for snapshots to be deleted by the empty-pre-post cleanup algorithm.
    EMPTY_PRE_POST_MIN_AGE = 3600; # default: 3600
  };
in
{
  config = lib.mkIf (config.boot.supportedFilesystems.btrfs or false) {
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

    # This is needed by snapper.
    systemd.tmpfiles.rules = lib.mapAttrsToList (
      name: value: "d ${lib.removeSuffix "/" value.SUBVOLUME}/.snapshots - root root - -"
    ) config.services.snapper.configs;
  };
}
