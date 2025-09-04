# TODO:
# - remove this file
# - put everything in its own directory
{
  lib,
  pkgs,
  self,
  ...
}: {
  # Move that to users/ratakor/default.nix?
  users.users.ratakor = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    description = "Ratakor";
    # TODO: change to initialHashedPassword
    initialPassword = "password"; # very secure
    extraGroups = [
      "wheel"
      # "audio"
      # "video"
      # "storage"
      # "network"
      "networkmanager"
      # "kvm"
    ];
    openssh.authorizedKeys.keys = self.keys.ratakor;
  };

  programs = {
    # TODO
    # Window Manager
    river-classic.enable = true; # river mop when?
    hyprland.enable = true;
    niri.enable = true;

    # uwsm = {
    #   enable = true;
    #   waylandCompositors = {
    #     river = {
    #       prettyName = "River";
    #       binPath = "/run/current-system/sw/bin/river";
    #     };
    #   };
    # };

    gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];
  };

  self.programs.pmount.enable = true;

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        # X11Forwarding = true;
        PermitRootLogin = "prohibit-password"; # disable root login with password
        PasswordAuthentication = false; # disable password login
      };
      openFirewall = true;
    };

    # used by gammastep
    geoclue2.enable = true;

    gnome = {
      # Disabled by default, but re-enabled by some packages:
      # niri: https://github.com/YaLTeR/niri/wiki/Important-Software#portals
      gnome-keyring.enable = lib.mkForce false;
      # gcr-ssh-agent.enable = false; # config.services.gnome.gnome-keyring.enable
    };
  };
}
