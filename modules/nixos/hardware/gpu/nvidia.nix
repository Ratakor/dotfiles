{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;

  dev = config.self.device;
  sys = config.self.system;
in
{
  config = mkIf (dev.gpu.type == "nvidia") {
    services.xserver.videoDrivers = [ "nvidia" ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    hardware = {
      nvidia = {
        open = mkDefault true;
        modesetting.enable = mkDefault true;
        nvidiaSettings = false;
        # nvidiaPersistenced = true; # is this useful?

        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault false;
          # kernelSuspendNotifier = true; # nixos enables it based on open / package version
        };

        # see prime.offload for hybrid gpu
      };

      # Enable Nvidia support for containers such as podman and docker.
      nvidia-container-toolkit.enable = sys.virt.podman.enable;

      graphics = {
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
        extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
      };
    };

    # https://niri-wm.github.io/niri/Nvidia.html
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
      ''
        {
          "rules": [
            {
              "pattern": {
                "feature": "procname",
                "matches": "niri"
              },
              "profile": "Limit Free Buffer Pool On Wayland Compositors"
            }
          ],
          "profiles": [
            {
              "name": "Limit Free Buffer Pool On Wayland Compositors",
              "settings": [
                {
                  "key": "GLVidHeapReuseRatio",
                  "value": 0
                }
              ]
            }
          ]
        }
      '';
  };
}
