{ lib, ... }:
let
  inherit (lib.filesystem) GiB;
in
{
  self = {
    device = {
      cpu.type = "intel";
      monitors = [
        {
          name = "China Star Optoelectronics Technology Co., Ltd MND508ZB1-1 Unknown";
          width = 2880;
          height = 1920;
          refreshRate = "60.000"; # "120.000"
          variableRefreshRate = true;
          scale = 2.0;
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
      bluetooth.enable = true;
      virt = {
        podman.enable = true;
        qemu.enable = true;
        distrobox.enable = true;
      };
      boot = {
        loader.systemd-boot.enable = true; # switch to lanzaboote?
      };
      # fs.zfs.arcMax = 5 * GiB;
      security = {
        fprint.enable = true;
      };
    };

    programs = {
      default = {
        desktopShell.name = "noctalia";
        # xdg.portal.name = "kde";
      };
      dev.enable = true;
      gaming = {
        enable = true;
        lutris.enable = true;
        wow.enable = true;
        poe.enable = false;
        minecraft.enable = false;
      };
      apps = {
        enable = true;
        teams.enable = true;
      };
      browser.tor-browser.enable = true;
      editor.zed.enable = true;
    };

    services = {
      ollama.enable = true;
    };
  };
}
