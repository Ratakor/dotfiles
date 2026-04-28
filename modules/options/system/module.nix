{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  cfg = config.self.system;
in
{
  imports = [
    ./boot.nix
    ./display-server.nix
    ./virtualisation.nix
  ];

  options.self.system = {
    audio.enable = mkEnableOption "audio drivers and related programs";
    video.enable = mkEnableOption "video drivers and related programs";
    bluetooth.enable = mkEnableOption "bluetooth drivers and related programs";
  };
}
