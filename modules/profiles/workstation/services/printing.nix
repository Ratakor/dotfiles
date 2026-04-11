# based on notashelf/nyx/modules/core/roles/workstation/system/services/printing.nix
{ pkgs, ... }:
{
  services = {
    # Enable CUPS and some drivers to common printers
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
      ];
    };

    # Required for network discovery of printers
    avahi = {
      enable = true;
      # Resolve .local domains for printers
      nssmdns4 = true;
      # Pass avahi port(s) to the firewall
      openFirewall = true;
    };
  };
}
