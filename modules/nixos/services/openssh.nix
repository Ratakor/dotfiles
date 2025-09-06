{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # X11Forwarding = true;
      PermitRootLogin = "prohibit-password"; # disable root login with password
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };
}
