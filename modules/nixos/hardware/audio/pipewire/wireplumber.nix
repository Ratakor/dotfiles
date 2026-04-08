{ config, ... }:
{
  # TODO: config wireplumber
  services.pipewire.wireplumber.enable = config.services.pipewire.enable;
}
