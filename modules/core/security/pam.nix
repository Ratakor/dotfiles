{
  security.pam = {
    services = {
      # keep the set even if empty to make swaylock work
      swaylock = {
        fprintAuth = false;
      };
    };
  };
}
