# https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS.html
# https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
# zpool options:
#   ashift=12 (depends on the drive & cannot be changed)
#
#   compression=on ("on" corresponds to the best algorithm aka lz4)
#   dedup=off (/!\ "on" means roughly -15% performance and x5 ram usage)
#   atime=off
#   relatime=on (note that relatime=on requires atime=on (need source))
#   xattr=sa
#   acltype=posixacl
#   normalization=none (use "formD" for compatibility with how macOS handles unicode)
#   autotrim=off (/!\ set this to "on" if using a modern nvme ssd)
#   com.sun:auto-snapshot=true (only on /home and /var)
#   recordsize=... currently keeping default, but maybe 1M for HDDs where storing large files
#
# https://forums.ghostbsd.org/d/406-is-zfs-reliable-on-ssds
# Make sure to create a reserved partition with 10-20% of the total disk capacity
# to preserve performance and maintain effective wear leveling.
# See additional information about SSDs on ZFS in the linked post.
#
# https://www.shpv.fr/blog/btrfs-vs-zfs-2026/
# - btrfs has slightly better performances unless
#   - when using LUKS encryption
#   - with ~70 snapshots then it decreases drastically
# - zfs has more features (encryption (per dataset), dedup (bad), RAID-Z)
# - zfs uses more ram
#
# https://despairlabs.com/blog/posts/2024-10-27-openzfs-dedup-is-good-dont-use-it/
# dedup sucks
# zdb -D for dedup stats
# zdb -S to simulate dedup
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.self.system.fs.zfs;
in
{
  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "zfs.zfs_arc_max=${toString cfg.arcMax}"
      ];
      zfs = {
        # https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#selecting-dev-names-when-creating-a-pool-linux
        # TODO: use by-partuuid for nixos VMs?
        devNodes = mkDefault "/dev/disk/by-id"; # default: /dev/disk/by-id

        # List of zpools to import at boot time.
        # Needed if not using legacy mountpoints.
        extraPools = mkDefault [ ];

        # If NixOS fails to boot because it cannot import the root pool, you
        # should boot with the zfs_force=1 option as a kernel parameter
        # (e.g. by manually editing the kernel params via your bootloader).
        # You should only need to do this after unclean shutdowns.
        forceImportRoot = false;
      };
    };

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
