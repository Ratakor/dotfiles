{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) elem;
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
      # Requires users to have "podman" (and "docker"?) group.
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

      # TODO: setup containers storage with btrfs/zfs
    };

    # Enable Nvidia support for containers such as podman and docker.
    hardware.nvidia-container-toolkit.enable = elem "nvidia" config.services.xserver.videoDrivers;
  };
}
