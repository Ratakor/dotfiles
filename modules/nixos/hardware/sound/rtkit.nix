{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkForce;
in
{
  # Required by pipewire
  security.rtkit.enable = mkForce config.services.pipewire.enable;
}
