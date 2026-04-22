{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.system.virt.podman;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman-compose
      # podman-desktop
    ];

    virtualisation = {
      podman = {
        enable = true;

        dockerCompat = true;
        dockerSocket.enable = true;

        # Required for containers under podman-compose to be able to communicate
        defaultNetwork.settings.dns_enabled = true;

        autoPrune = {
          enable = true; # idk why not
          flags = [ "--all" ];
          dates = "weekly";
        };
      };
    };
  };
}
