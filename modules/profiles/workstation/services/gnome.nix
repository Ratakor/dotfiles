{ pkgs, ... }:
{
  services = {
    udev.packages = [ pkgs.gnome.gnome-settings-daemon ];

    # Disabled by default, but re-enabled / needed by some packages:
    # niri: https://github.com/YaLTeR/niri/wiki/Important-Software#portals
    # spotify, chromium, ...
    gnome = {
      gnome-keyring.enable = true; # mkForce false;
      # gcr-ssh-agent.enable = false; # config.services.gnome.gnome-keyring.enable
    };
  };
}
