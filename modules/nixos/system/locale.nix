{
  # Set your time zone
  time.timeZone = "Europe/Paris";

  location = {
    # "manual" or "geoclue2"
    # Setting it to "geoclue2" will enable the corresponding service
    provider = "geoclue2";
    # Paris iirc
    latitude = 48.8;
    longitude = 2.3;
  };

  # Select internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      #   LC_ADDRESS = "fr_FR.UTF-8";
      #   LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      #   LC_MONETARY = "fr_FR.UTF-8";
      #   LC_NAME = "fr_FR.UTF-8";
      #   LC_NUMERIC = "fr_FR.UTF-8";
      #   LC_PAPER = "fr_FR.UTF-8";
      #   LC_TELEPHONE = "fr_FR.UTF-8";
      #   LC_TIME = "fr_FR.UTF-8";
    };
  };
}
