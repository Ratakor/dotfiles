# Screen color temperature adjuster -- No blue light at night
# Check out `sunsetr` for a pretty cool pure Wayland alternative
{
  hm.services.gammastep = {
    enable = true;
    settings.general.fade = 0;
    temperature.day = 6000;
    temperature.night = 3000;
    provider = "geoclue2";
    # provider = "manual";
    # latitude = 48.8;
    # longitude = 2.3;
  };

  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = false;
  };
}
