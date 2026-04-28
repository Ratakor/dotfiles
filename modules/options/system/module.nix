# Software configuration for the system
{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self.system = {
    audio.enable = mkEnableOption "audio drivers and related programs";
    video.enable = mkEnableOption "video drivers and related programs";
    bluetooth.enable = mkEnableOption "bluetooth drivers and related programs";
  };
}
