# A virtual microphone device with noise suppression
{ config, ... }:
let
  cfg = config.self.system.audio;
in
{
  # TODO: add a service (like in nyx/homes/notashelf/services/shared/media/noisetorch.nix)
  programs.noisetorch.enable = cfg.enable;
}
