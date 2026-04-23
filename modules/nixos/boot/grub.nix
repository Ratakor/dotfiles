{ config, lib, ... }:
let
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.self.system.boot.loader;
in
{
  config = mkIf cfg.grub.enable {
    boot.loader.grub = {
      enable = true;
      inherit (cfg) configurationLimit;
      inherit (cfg.grub) device;
      efiSupport = cfg.grub.device == "nodev";
      zfsSupport = config.boot.zfs.enabled;
      # Append entries of other OSs detected by os-prober.
      useOSProber = false;
      # Enable support for encrypted partitions.
      enableCryptodisk = mkDefault false;
      # Index of the default menu item to be booted.
      # Can also be set to "saved", which will make GRUB
      # select the menu item that was used at the last boot.
      default = mkDefault "0"; # default: "0"
    };
  };
}
