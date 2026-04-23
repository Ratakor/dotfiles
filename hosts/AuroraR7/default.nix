{
  imports = [
    ./hardware-configuration.nix
  ];

  self = {
    colors = {
      theme = "gruvbox";
      variant = "dark";
    };

    system = {
      displayServer.wayland = true;
      audio.enable = true;
      video = {
        enable = true;
        nvidia.enable = true;
      };
      bluetooth.enable = false;
      virt = {
        podman.enable = true;
        qemu.enable = true;
      };
      boot = {
        loader.systemd-boot.enable = true;
      };
    };

    programs = {
      terminal.fontSize = 16;
      default = {
        terminal.name = "ghostty";
      };
      gaming = {
        enable = true;
      };
    };
  };

  # TODO: setup snapshots
  services.btrfs = {
    autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
      interval = "monthly";
    };
  };
}
