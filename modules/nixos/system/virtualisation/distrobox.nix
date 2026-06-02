# Setup container with latest Arch Linux image
# distrobox create --root --name archlinux --init --image archlinux:latest
#
# Enter Arch Linux container
# distrobox enter --root archlinux
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatMapStringsSep;

  cfg = config.self.system.virt.distrobox;

  additionalVolumes = concatMapStringsSep " " (path: "${path}:${path}:ro") [
    "/nix/store"
    "/etc/profiles/per-user"
    "/etc/static/profiles/per-user"
    # "/etc/static"
    # "/run/current-system"
  ];
in
{
  config = mkIf cfg.enable {
    environment = {
      systemPackages = singleton pkgs.distrobox;
      etc."distrobox/distrobox.conf".text = ''
        container_additional_volumes="${additionalVolumes}"
      '';
    };

    systemd = mkIf cfg.autoUpgrade.enable {
      services.distrobox-upgrade = {
        script = "${getExe pkgs.distrobox} upgrade --all";
        restartIfChanged = false;
        serviceConfig.Type = "oneshot";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };

      # 1h after boot then weekly
      timers.distrobox-upgrade = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1h";
          OnUnitActiveSec = "1w";
          Unit = "distrobox-upgrade.service";
        };
      };
    };
  };
}
