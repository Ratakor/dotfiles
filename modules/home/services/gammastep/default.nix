# Screen color temperature adjuster -- No blue light at night
# Check out `sunsetr` for a pretty cool pure Wayland alternative
{ config, ... }:
{
  hm.services.gammastep = {
    enable = true;
    settings.general.fade = 0;
    temperature.day = 6000;
    temperature.night = 3000;
    inherit (config.location) provider latitude longitude;
  };

  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = false;
  };
}
