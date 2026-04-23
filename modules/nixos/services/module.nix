{ config, ... }:
{
  imports = [
    ./login.nix
    ./openssh.nix
  ];

  services = {
    # enable NTP client to sync time
    ntp.enable = true;

    # Replace some perl scripts and stuff idk but I think it's good
    # see also https://github.com/feel-co/nixos-core
    userborn.enable = true;

    # Enable the X11 windowing system
    xserver.enable = config.self.system.displayServer.x11;
  };
}
