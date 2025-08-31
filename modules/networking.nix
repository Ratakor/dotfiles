{
  networking = {
    # https://github.com/StevenBlack/hosts
    stevenblack = {
      enable = true;
      block = []; # Additional flavors to block
    };

    # Pick only one of the below networking options.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;
    # interfaces.eno0.useDHCP = lib.mkDefault true;
    # interfaces.wlp2s0.useDHCP = lib.mkDefault true;

    firewall = {
      enable = true;
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };
}
