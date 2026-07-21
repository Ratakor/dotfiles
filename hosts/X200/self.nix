{ config, lib, ... }:
let
  inherit (lib.filesystem) GiB;

  dprg = config.self.programs.default;
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
        desktopShell.name = "noctalia";
        # launcher.name = "fuzzel";
        # windowManager.name = "river-classic";
        # desktopShell.name = null;
        # powerMenu.name = "wlogout";
        # statusBar.name = "waybar";
        # locker.name = "glitchlock";
      };
      dev.enable = true;
      scripts = {
        enable = true;
        randwp.enable = true;
      };
      apps = {
        enable = true;
        spotify.enable = false; # crashes with illegal instruction
      };
      terminal.fontSize = 10;
      windowManager = {
        niri.extraConfig = /* kdl */ ''
          spawn-at-startup "randwp"
          binds {
            Mod+Shift+W repeat=false hotkey-overlay-title="Set a random wallpaper" { spawn "randwp"; }
          }

          blur {
            off
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
      swayidle.enable = dprg.windowManager.name == "river-classic";
      mako.enable = false; # TODO: noctalia (and DMS?) handles notifications
    };

    disabledPackages = [
      "antigravity-cli" # requires AES instruction set
      "claude-code" # crashes with illegal hardware instruction
    ];
  };
}
