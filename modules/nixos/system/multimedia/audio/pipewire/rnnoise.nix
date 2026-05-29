# https://github.com/werman/noise-suppression-for-voice?tab=readme-ov-file#linux
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.system.audio.pipewire.rnnoise;
in
{
  config = mkIf cfg.enable {
    services.pipewire = {
      extraLadspaPackages = [ pkgs.rnnoise-plugin.ladspa ];
      extraConfig.pipewire."99-input-denoising" = {
        "context.modules" = [
          {
            "name" = "libpipewire-module-filter-chain";
            # flags = [ "ifexists" "nofail" ];
            "args" = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";
              "filter.graph" = {
                "nodes" = [
                  {
                    "type" = "ladspa";
                    "name" = "rnnoise";
                    "plugin" = "librnnoise_ladspa";
                    "label" = "noise_suppressor_mono"; # "noise_suppressor_stereo" consumes 2x resources
                    "control" = {
                      "VAD Threshold (%)" = cfg.vadThreshold;
                      "VAD Grace Period (ms)" = cfg.vadGracePeriod;
                      "Retroactive VAD Grace (ms)" = cfg.retroactiveVadGrace;
                    };
                  }
                ];
              };
              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
                "audio.rate" = 48000;
              };
              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
              };
              # https://wiki.archlinux.org/title/PipeWire#Noise_suppression_for_voice
              "audio.channels" = 1;
              "audio.position" = [ "MONO" ]; # change to [ "FL", "FR" ] for stereo
            };
          }
        ];
      };
    };
  };
}
