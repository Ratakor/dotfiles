{ config, ... }:
{
  time.timeZone = "Europe/Paris";

  location = {
    # "manual" or "geoclue2"
    # Setting it to "geoclue2" will enable the corresponding service
    provider = "geoclue2";
    # Paris iirc
    latitude = 48.8;
    longitude = 2.3;
  };

  # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
  i18n.defaultLocale = "en_IE.UTF-8";

  services.xserver.xkb = {
    inherit (config.self.system.keyboard) layout variant options;
  };

  console.useXkbConfig = true;
}
