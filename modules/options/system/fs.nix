{ config, lib, ... }:
let
  inherit (builtins) attrValues any all;
  inherit (lib.options) mkOption;
  inherit (lib) types;

  mkFsEnableOption =
    fs:
    mkOption {
      type = types.bool;
      default = any (v: v.fsType == fs) (attrValues config.fileSystems);
      defaultText = lib.literalMD "`true` if a `${fs}` filesystem is found";
      description = "Whether to enable ${fs} services and specific configurations.";
    };

  cfg = config.self.system.fs;
in
{
  options.self.system.fs = {
    btrfs = {
      enable = mkFsEnableOption "btrfs";
      autoSnapshot = {
        subvolumes = mkOption {
          type = types.attrsOf types.str;
          default = { };
          example = {
            root = "/";
            home = "/home";
            var = "/var";
          };
          description = "List of btrfs mount points to periodically snapshot.";
        };
      };
    };

    zfs = {
      enable = mkFsEnableOption "zfs";
      # https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Module%20Parameters.html#zfs-arc-max
      # https://blog.thalheim.io/2025/10/17/zfs-ate-my-ram-understanding-the-arc-cache/
      arcMax = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          The maximum size (in bytes) of the ZFS Adaptive Replacement Cache (ARC).
          If set to 0, the larger of `all_system_memory - 1GB` and `5/8 × all_system_memory` will be used.
          A minimum of 2GB is recommended although more is strongly recommended.
          As a rule of thumb ZFS needs 1GB minimum + 1GB of RAM per 1TB of storage,
          that can go up to 5GB of RAM per 1TB of storage with deduplication enabled.
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion =
          cfg.btrfs.autoSnapshot.subvolumes
          |> attrValues
          |> all (path: config.fileSystems.${path}.fsType == "btrfs");
        message = "All mount points in `self.system.fs.btrfs.autoSnapshot.subvolumes` must exist and be of \"btrfs\" fsType.";
      }
    ];
  };
}
