{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  imports = [
    ./openssh.nix
  ];

  services = {
    # Enable CUPS to print documents
    printing.enable = true;

    # enable NTP client to sync time
    ntp.enable = true;

    # TODO: is userborn useful?
    userborn.enable = false;

    # used by gammastep
    geoclue2.enable = true;

    gnome = {
      # Disabled by default, but re-enabled by some packages:
      # niri: https://github.com/YaLTeR/niri/wiki/Important-Software#portals
      gnome-keyring.enable = mkForce false;
      # gcr-ssh-agent.enable = false; # config.services.gnome.gnome-keyring.enable
    };
  };
}
