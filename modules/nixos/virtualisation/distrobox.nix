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

  cfg = config.self.system.virt.distrobox;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = singleton pkgs.distrobox;

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
