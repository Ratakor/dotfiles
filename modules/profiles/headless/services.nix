{ pkgs, ... }:
{
  services = {
    udisks2.enable = false;
    xserver.excludePackages = [ pkgs.xterm ];
  };
}
