{ lib, ... }:
let
  inherit (lib.filesystem) GiB;
in
{
  self = {
    device = {
      # ram.size = 7770156; # obtained using `free`
      # storage.size = 118907821568; # obtained using `fdisk -l`
      cpu.type = "intel";
      # no GPU and let niri figure out about monitors
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
      };
      boot = {
        loader.grub = {
          enable = true;
          device = "/dev/sda";
        };
      };
      fs.zfs.arcMax = 2 * GiB;
    };

    programs = {
      terminal.fontSize = 10;
      windowManager.niri.extraConfig = /* kdl */ ''
        spawn-at-startup "randwp"
        binds {
          Mod+Shift+W repeat=false hotkey-overlay-title="Set a random wallpaper" { spawn "randwp"; }
        }
      '';
      default = {
        terminal.name = "foot";
      };
    };

    services = {
      wpaperd.enable = false;
    };
  };
}
