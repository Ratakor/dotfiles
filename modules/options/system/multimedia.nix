# Software configuration for the system
{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) types;
in
{
  options.self.system = {
    audio = {
      enable = mkEnableOption "audio drivers and related programs";
      pipewire = {
        rnnoise = {
          enable = mkEnableOption "rnnoise";
          vadThreshold = mkOption {
            type = types.ints.between 0 99;
            default = 90; # default: 50, recommended: 85-95
            description = ''
              Set the rnnoise VAD threshold (%).

              If probability of sound being a voice is lower than this threshold
              then it will be silenced. In most cases the threshold between
              85% - 95% would be fine. Without the VAD some loud noises may
              still be a bit audible when there is no voice.
            '';
          };
          vadGracePeriod = mkOption {
            type = types.ints.between 0 1000;
            default = 200;
            description = ''
              Set the rnnoise VAD grace period in milliseconds.

              For how long after the last voice detection the output won't be
              silenced. This helps when ends of words/sentences are being cut off.
            '';
          };
          retroactiveVadGrace = mkOption {
            type = types.ints.between 0 200;
            default = 0;
            description = ''
              Set the rnnoise retroactive VAD grace period in milliseconds.

              Similar to VAD Grace Period (ms) but for starts of words/sentences.
              /!\ This introduces latency!
            '';
          };
        };
      };
    };
    video.enable = mkEnableOption "video drivers and related programs";
    bluetooth.enable = mkEnableOption "bluetooth drivers and related programs";
  };
}
