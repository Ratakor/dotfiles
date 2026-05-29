{ config, ... }:
let
  cfg = config.self.system.audio;
in
{
  services.pulseaudio.enable = cfg.enable && !config.services.pipewire.enable;
}
