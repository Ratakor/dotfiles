{ config, lib, ... }:
let
  inherit (builtins) substring hashString;
  inherit (lib.modules) mkDefault;
in
{
  networking = {
    # needed by ZFS, also need to be unique among all hosts
    hostId = substring 0 8 (hashString "md5" config.networking.hostName);

    # https://github.com/StevenBlack/hosts
    stevenblack = {
      enable = true;
      block = [ ]; # Additional flavors to block
    };

    # Pick only one of the below networking options.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;

    # I've heard that networkd > dhcp
    # That was _probably_ fake news, it's only better for servers
    # https://wiki.nixos.org/wiki/Systemd/networkd
    useDHCP = mkDefault true;
    useNetworkd = mkDefault false; # check out systemd.network.enable too

    firewall = {
      enable = true;
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };

    nameservers = [
      # Quad9
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"

      # Cloudflare
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };
}
