{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkForce;

  cfg = config.self.system.audio;
in
{
  services.pulseaudio.enable = mkForce (cfg.enable && !config.services.pipewire.enable);
}
