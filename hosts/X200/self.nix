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

        # desktopShell.name = null;
        # windowManager.name = "river-classic";
        # launcher.name = "fuzzel";
        # powerMenu.name = "wlogout";
        # statusBar.name = "waybar";
        # locker.name = "glitchlock";
        # notification.name = "mako";
        # wallpaper.name = "randwp";
      };
      dev.enable = true;
      scripts.enable = true;
      apps = {
        enable = true;
        spotify.enable = false; # crashes with illegal instruction
      };
      terminal.fontSize = 10;
      windowManager = {
        niri.extraConfig = /* kdl */ ''
          blur {
            off
          }

          // https://github.com/niri-wm/niri/issues/4043
          layer-rule {
            match namespace="^launcher$" // this is necessary
            background-effect {
              xray true
            }
          }
        '';
      };
    };

    services = {
      swayidle.enable = dprg.windowManager.name == "river-classic";
    };

    disabledPackages = [
      "antigravity-cli" # requires AES instruction set
      "claude-code" # crashes with illegal hardware instruction
    ];
  };
}
