{ config, lib, ... }:
{
  config = lib.mkIf config.boot.supportedFilesystems.btrfs {
    services = {
      btrfs.autoScrub = {
        enable = true;
        # fileSystems = [ "/" ]; # let nixos figure it out
        interval = "monthly"; # default: monthly
      };
    };
  };
}
