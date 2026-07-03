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
      default = {
        terminal.name = "foot";
        launcher.name = "fuzzel";
        windowManager.name = "river-classic";
        desktopShell.name = null;
        powerMenu.name = "wlogout";
        statusBar.name = "waybar";
        locker.name = "glitchlock";
      };
      dev.enable = true;
      scripts = {
        enable = true;
        randwp.enable = true;
      };
      apps.enable = true;
      terminal.fontSize = 10;
      windowManager = {
        niri.extraConfig = /* kdl */ ''
          spawn-at-startup "randwp"
          binds {
            Mod+Shift+W repeat=false hotkey-overlay-title="Set a random wallpaper" { spawn "randwp"; }
          }
        '';
        river-classic.extraConfig = /* sh */ ''
          riverctl spawn 'randwp'
          riverctl map normal Super+Shift W spawn 'randwp'
        '';
      };
    };

    services = {
      wpaperd.enable = false;
      swayidle.enable = true;
    };

    disabledPackages = [
      "antigravity-cli" # requires AES instruction set
    ];
  };
}
