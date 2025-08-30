# no blue light at night
{
  services.gammastep = {
    enable = true;
    settings.general.fade = 0;
    temperature.day = 6000;
    temperature.night = 3000;
    provider = "geoclue2";
    # provider = "manual";
    # latitude = 48.8;
    # longitude = 2.3;
  };
}
