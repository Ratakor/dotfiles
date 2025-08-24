# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/system.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

  boot.loader = {
    # systemd-boot = {
    #   enable = true;
    #   zfsSupport = true;
    #   configurationLimit = 50;
    # }
    grub = {
      enable = true;
      zfsSupport = true; # https://nixos.wiki/wiki/ZFS
      efiSupport = false;
      default = 1; # weird ZFS bug I think
      # enableCryptodisk = true;
      # useOSProber = true;
      # eifInstallAsRemovable = true;
      # mirroredBoots = [
      #   { devices = [ "nodev" ]; path = "/boot"; }
      # ];
      device = "/dev/sda"; # or "nodev" for efi only
      configurationLimit = 50; # Limit the number of generations to keep
    };
    # efi = {
    #   canTouchEfiVariables = true;
    #   efiSysMountPoint = "/boot/efi";
    # }
    timeout = 1;
  };

  networking = {
    hostName = "X200";
    hostId = "90431314"; # needed by ZFS
    stevenblack.enable = true;

    # Pick only one of the below networking options.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # https://github.com/bluez/bluez/blob/master/src/main.conf
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.zfs = {
    autoReplication = {
      enable = false;
    };

    autoScrub = {
      enable = true;
      pools = ["zpool"];
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
