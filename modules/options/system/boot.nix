{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str int raw;

  cfg = config.self.system.boot;
in
{
  options.self.system.boot = {
    loader = {
      systemd-boot.enable = mkEnableOption "systemd-boot EFI boot manager";
      grub = {
        enable = mkEnableOption "GNU GRUB boot loader";
        device = mkOption {
          type = str;
          default = "nodev"; # "nodev" is for EFI only
          description = "The device on which the GRUB boot loader will be installed.";
        };
      };
      configurationLimit = mkOption {
        type = int;
        default = 100;
        description = "Maximum of generations in boot menu.";
      };
    };

    kernel = mkOption {
      type = raw;
      default =
        if config.boot.zfs.enabled then pkgs.linuxPackages_xanmod else pkgs.linuxPackages_xanmod_latest;
      description = "The kernel packages to use for the system.";
    };

    tmpAsTmpfs = mkEnableOption "mount `/tmp` as tmpfs";
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.loader.systemd-boot.enable && cfg.loader.grub.enable);
        message = "You cannot enable both systemd-boot and GRUB boot loaders simultaneously.";
      }
    ];
  };
}
