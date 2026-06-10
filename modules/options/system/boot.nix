{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOption literalExpression;
  inherit (lib.types) str int raw;
  inherit (lib.lists) count;

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
      lanzaboote.enable = mkEnableOption "Lanzaboote Secure Boot";

      configurationLimit = mkOption {
        type = int;
        default = 100;
        description = "Maximum of generations in boot menu.";
      };
    };

    kernel = mkOption {
      type = raw;
      # see also pkgs.linuxPackages_xanmod
      default = if config.boot.zfs.enabled then pkgs.linuxPackages else pkgs.linuxPackages_latest;
      defaultText = literalExpression ''
        if config.boot.zfs.enabled then pkgs.linuxPackages else pkgs.linuxPackages_latest
      '';
      description = "The kernel packages to use for the system.";
    };

    tmpAsTmpfs = mkEnableOption "mount `/tmp` as tmpfs";
  };

  config = {
    assertions = [
      {
        assertion =
          count (x: x.enable) [
            cfg.loader.systemd-boot
            cfg.loader.grub
            cfg.loader.lanzaboote
          ] <= 1;
        message = "You cannot enable more than one boot loader.";
      }
    ];
  };
}
