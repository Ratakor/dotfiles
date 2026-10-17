{ config, lib, ... }:
let
  inherit (lib.filesystem) GiB;

  dprg = config.self.programs.default;
in
{
  self = {
    device = {
      cpu.type = "intel";
      monitors = [ ]; # TODO
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
        poe.enable = false; # ?
        wow.enable = false; # ?
        minecraft.enable = false; # ?
      };
      apps = {
        enable = true;
        teams.enable = true;
      };
      editor.zed.enable = true;
    };
  };
}
