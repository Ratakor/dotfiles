{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault mkForce;

  cfg = config.self.system.boot.loader;
in
{
  imports = [ sources.lanzaboote.nixosModules.default ];

  config = mkIf cfg.lanzaboote.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    boot = {
      initrd.systemd.enable = mkDefault true;

      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      loader.systemd-boot.enable = mkForce false;

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";

        # autoGenerateKeys.enable = true;
        # autoEnrollKeys.enable = true; # requires reboot

        # Share similar settings with systemd-boot.
        inherit (cfg) configurationLimit;
        # Default is true but it's recommended to set it to false as it's a
        # security hole that could allow gaining root access by passing init=/bin/sh
        settings.editor = false;
      };
    };
  };
}
