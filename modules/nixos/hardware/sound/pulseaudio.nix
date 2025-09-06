{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  services.pulseaudio.enable = mkForce (!config.services.pipewire.enable);
}
