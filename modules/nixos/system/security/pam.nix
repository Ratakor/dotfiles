{
  security.pam = {
    services = {
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
      # none this doesn't seem to work :(
      login.enableGnomeKeyring = true;
      # ly pam config is already done by nixos' ly module
      # ly-autologin.enableGnomeKeyring = true;
      # gdm-autologin.enableGnomeKeyring = true;
      # passwd.enableGnomeKeyring = true;
    };
  };
}
