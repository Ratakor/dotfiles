{
  imports = [
    ./hardware-configuration.nix
  ];

  self = {
    colors = {
      theme = "gruvbox";
      variant = "dark";
    };
    fontSize = 16;

    system = {
      displayServer = "wayland";
      audio.enable = true;
      video = {
        enable = true;
        nvidia.enable = true;
      };
      bluetooth.enable = false;
    };

    programs = {
      windowManager = "niri";
      terminal.program = "ghostty";
      imageViewer.program = "imv";
      locker.program = "dms";
      gaming = {
        enable = true;
      };
    };
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      # zfsSupport = true;
      configurationLimit = 50;
    };
    timeout = 1;
  };

  # TODO: setup snapshots
  services.btrfs = {
    autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
      interval = "monthly";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
