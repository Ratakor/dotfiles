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
      nvidia.enable = mkEnableOption "nvidia drivers and related programs";
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
