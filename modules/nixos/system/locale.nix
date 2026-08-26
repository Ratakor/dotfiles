{ config, ... }:
{
  time.timeZone = "Europe/Paris";

  location = {
    inherit (config.self.system.location) provider latitude longitude;
  };

  # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
  i18n.defaultLocale = "en_IE.UTF-8";

  services.xserver.xkb = {
    inherit (config.self.system.keyboard) layout variant options;
  };

  console.useXkbConfig = true;
}
