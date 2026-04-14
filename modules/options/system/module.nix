{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) enum;
  inherit (lib.lists) optional;

  cfg = config.self.system;
in
{
  options.self.system = {
    audio.enable = mkEnableOption "audio drivers and related programs";

    video = {
      enable = mkEnableOption "video drivers and related programs";
      nvidia = {
        enable = mkEnableOption "nvidia drivers and related programs";
        package = mkOption {
          # Based on default for `hardware.nvidia.package`.
          # See also datacenter package.
          default = config.boot.kernelPackages.nvidiaPackages.stable;
          description = "The nvidia driver package to use.";
        };
      };
    };

    bluetooth.enable = mkEnableOption "bluetooth drivers and related programs";

    displayServer = mkOption {
      type = enum [
        "x11"
        "wayland"
        "none"
      ];
      default = "none";
      description = "The display server to use.";
    };
  };

  config = {
    system.nixos.tags = optional (cfg.displayServer != "none") cfg.displayServer;
  };
}
