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
    #   configurationLimit = 10;
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
    # timeout = 10; # TODO
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
}
