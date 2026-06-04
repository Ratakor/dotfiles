{ pkgs, ... }:
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
          refreshRate = "119.998"; # 143.999 is broken
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
      login = {
        autoLogin = true;
        manager = "tuigreet";
      };
      audio = {
        enable = true;
        pipewire.rnnoise.enable = true;
      };
      video.enable = true;
      bluetooth.enable = false;
      virt = {
        podman.enable = true;
        qemu.enable = true;
        distrobox.enable = true;
      };
      boot = {
        loader.lanzaboote.enable = true;
      };
      fs.btrfs.autoSnapshot.subvolumes = {
        home = "/home";
        storage = "/storage";
      };
    };

    programs = {
      default = {
        # xdg.portal.name = "kde";
      };
      dev.enable = true;
      scripts.enable = true;
      gaming = {
        enable = true;
        poe.enable = true;
      };
      apps = {
        enable = true;
        teams.enable = true;
      };
      browser = {
        tor-browser.enable = true;
        chromium.package = pkgs.ungoogled-chromium;
      };
      terminal.foot.enable = true; # just in case ghostty doesn't work
      editor.visual.zed.enable = true;
    };
  };
}
