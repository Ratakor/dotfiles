{ keys, pkgs, ... }:
{
  self = {
    device = {
      cpu.type = "amd";
      monitors = [
        {
          name = "BOE NE135A1M-NY1 Unknown";
          width = 2880;
          height = 1920;
          refreshRate = "60.001";
          variableRefreshRate = true;
          scale = 2.0;
        }
      ];
    };

    user = {
      name = "matthieu";
      fullName = "Matthieu Crémel";
      email = "matt.cremel@gmail.com";
      keys = keys.ratakor;
    };

    system = {
      login = {
        autoLogin = true;
        manager = "ly"; # ?
      };
      audio = {
        enable = true;
        pipewire.rnnoise.enable = true;
      };
      video.enable = true;
      bluetooth.enable = true;
      boot = {
        loader.systemd-boot.enable = true;
      };
      fs.btrfs.autoSnapshot.subvolumes = {
        home = "/home";
        # var = "/var";
      };
      keyboard = {
        layout = "fr";
        variant = "";
        options = "";
      };
      security = {
        fprint.enable = true;
      };
    };

    programs = {
      default = {
        editor.visual.name = "zed";
        locker.name = "glitchlock";
      };
      gaming = {
        enable = true;
        lutris.enable = false; # TODO: should be true
      };
      apps = {
        anki.enable = true;
        gajim.enable = false;
        keepassxc.enable = false;
        libreoffice.enable = true;
        obs-studio.enable = true;
      };
      email.thunderbird.dove = false;
      windowManager.niri.extraConfig = /* kdl */ ''
        binds {
          Mod+Shift+Colon hotkey-overlay-title=null { show-hotkey-overlay; }

          Mod+ampersand { focus-workspace 1; }
          Mod+eacute { focus-workspace 2; }
          Mod+quotedbl { focus-workspace 3; }
          Mod+apostrophe { focus-workspace 4; }
          Mod+parenleft { focus-workspace 5; }
          Mod+minus { focus-workspace 6; }
          Mod+egrave { focus-workspace 7; }
          Mod+underscore { focus-workspace 8; }
          Mod+ccedilla { focus-workspace 9; }
          Mod+Shift+ampersand { move-column-to-workspace 1; }
          Mod+Shift+eacute { move-column-to-workspace 2; }
          Mod+Shift+quotedbl { move-column-to-workspace 3; }
          Mod+Shift+apostrophe { move-column-to-workspace 4; }
          Mod+Shift+parenleft { move-column-to-workspace 5; }
          Mod+Shift+minus { move-column-to-workspace 6; }
          Mod+Shift+egrave { move-column-to-workspace 7; }
          Mod+Shift+underscore { move-column-to-workspace 8; }
          Mod+Shift+ccedilla { move-column-to-workspace 9; }
        }
      '';
    };

    services = {
      udiskie.enable = true;
      syncthing.enable = false;
    };
  };
}
