{
  self = {
    device = {
      cpu.type = "intel";
      gpu.type = "nvidia";
      monitors = [
        {
          name = "Microstep MSI MPG27CQ2 0x30304E37";
          width = 2560;
          height = 1440;
          # refreshRate = "119.998"; # 143.999 is broken
          variableRefreshRate = true;
          scale = 1.3;
        }
        {
          name = "Ancor Communications Inc VX238 GCLMRS016906";
          width = 1920;
          height = 1080;
          refreshRate = "60.000";
          x = 1970;
          y = 130;
        }
      ];
    };

    system = {
      displayServer.wayland = true;
      audio = {
        enable = true;
        pipewire.rnnoise.enable = true;
      };
      video.enable = true;
      bluetooth.enable = false;
      virt = {
        podman.enable = true;
        qemu.enable = true;
      };
      boot = {
        loader.systemd-boot.enable = true;
      };
      fs.btrfs.autoSnapshot.subvolumes = {
        # home = "/home";
      };
    };

    programs = {
      terminal = {
        fontSize = 16;
        foot.enable = true; # just in case ghostty doesn't work
      };
      default = {
        terminal.name = "ghostty";
      };
      gaming = {
        enable = true;
        poe.enable = true;
      };
    };
  };
}
