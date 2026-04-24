{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault;

  cfg = config.self.system.boot;
in
{
  imports = [
    ./grub.nix
    ./systemd-boot.nix
  ];

  boot = {
    kernelPackages = cfg.kernel;

    # Whether to enable support for Linux MD RAID arrays.
    # You should use the far superior RAID-Z feature from ZFS instead anyway.
    swraid.enable = false;

    loader = {
      # Timeout until loader boots the default menu system.
      # If set to 0 space needs to be held to get the boot menu to appear.
      timeout = 2;

      # Allows to boot without nix store via copyKernels.
      generationsDir = {
        enable = false; # Conflicts with systemd-boot.
        copyKernels = true;
      };

      # idk this probably useful
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      # Whether to mount /tmp as tmpfs.
      # This reduces disk usage but it's mostly a bad idea imo since
      # large (nix) build can fail if /tmp is not large enough.
      useTmpfs = cfg.tmpAsTmpfs;
      tmpfsSize = mkDefault "50%"; # default: 50%
      # Whether to delete all files in /tmp during boot.
      cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
    };
  };
}
