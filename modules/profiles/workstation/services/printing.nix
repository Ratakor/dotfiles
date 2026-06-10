# https://wiki.nixos.org/wiki/Printing
{ pkgs, ... }:
{
  services = {
    # Enable CUPS and some drivers to common printers
    printing = {
      enable = true;
      webInterface = true; # localhost:631
      drivers = with pkgs; [
        gutenprint # Drivers for many different printers from many different vendors
        hplip # Drivers for HP printers
        epson-escpr2 # Drivers for Epson AirPrint devices
        cups-filters
        cups-browsed
      ];
    };

    # Required for network discovery of printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
