{
  security.pam = {
    services = {
      # keep the set even if empty to make swaylock work
      swaylock = {
        fprintAuth = false;
      };
      # Unlock gnome-keyring and GPG on login via greetd.
      # Replace greetd with login if using another display manager.
      # https://wiki.nixos.org/wiki/Secret_Service#Auto-decrypt_on_login
      greetd = {
        enableGnomeKeyring = true;
        # gnupg = {
        #   enable = true;
        #   noAutoStart = true;
        #   storeOnly = true;
        # };
      };
    };
  };
}
