{
  imports = [
    # hardware-configuration.nix should probably be merged here or sorted e.g.
    # filesystem.nix with all zfs stuff, etc...
    ./hardware-configuration.nix
  ];

  self = {
    colors = {
      theme = "gruvbox";
      variant = "dark";
    };

    device = {
      ram.size = 7770156; # obtained using `free`
      # storage.size = 118907821568; # obtained using `fdisk -l`
      cpu.type = "intel";
      # no GPU and let niri figure out about monitors
    };

    system = {
      displayServer.wayland = true;
      audio.enable = true;
      video.enable = true;
      bluetooth.enable = false;
      virt = {
        podman.enable = true;
      };
      boot = {
        loader.grub = {
          enable = true;
          device = "/dev/sda";
        };
      };
    };
  };

  # weird bug can't boot on index 0 iirc
  boot.loader.grub.default = 1;
}
