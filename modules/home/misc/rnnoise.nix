{ pkgs, ... }:
let
  json = pkgs.formats.json { };
in
{
  # https://github.com/werman/noise-suppression-for-voice?tab=readme-ov-file#linux
  hm.xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf".source =
    json.generate "99-input-denoising.conf"
      {
        "context.modules" = [
          {
            "name" = "libpipewire-module-filter-chain";
            "args" = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";
              "filter.graph" = {
                "nodes" = [
                  {
                    "type" = "ladspa";
                    "name" = "rnnoise";
                    "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    "label" = "noise_suppressor_mono"; # "noise_suppressor_stereo" consumes 2x resources
                    "control" = {
                      "VAD Threshold (%)" = 90.0; # default: 50.0, recommended: 85-95
                      "VAD Grace Period (ms)" = 200; # default: 200
                      "Retroactive VAD Grace (ms)" = 0; # default: 0
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
}
