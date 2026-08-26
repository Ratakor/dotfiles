{ config, lib, ... }:
let
  inherit (lib.modules) mkDefault;
in
{
  time.timeZone = mkDefault "Europe/Paris";

  location = {
    provider = mkDefault "manual"; # "manual" or "geoclue2"
    # Paris
    latitude = 48.8;
    longitude = 2.3;
  };

  # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
  i18n.defaultLocale = mkDefault "en_IE.UTF-8";

  services.xserver.xkb = {
    inherit (config.self.system.keyboard) layout variant options;
  };

  console.useXkbConfig = true;
}
