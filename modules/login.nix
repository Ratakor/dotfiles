# https://kl.wtf/posts/2022/03/12/login-managers-an-introduction.html
{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.meta) getExe getExe';
in {
  services = {
    getty = {
      autologinOnce = true;
      autologinUser = "ratakor";
    };

    # TODO: doesn't work with river/hyprland
    greetd = {
      enable = false;
      settings = {
        vt = 1;

        # autologin
        initial_session = {
          command = getExe' pkgs.niri "niri-session";
          user = "ratakor";
        };

        # fallback
        default_session = {
          command = concatStringsSep " " [
            (getExe pkgs.tuigreet)
            "--time"
            "--asterisks"
            "--remember"
            "--remember-user-session"
            # "--cmd 'zsh'"
          ];
          user = "greeter";
        };
      };
    };

    displayManager = {
      # enable = lib.mkForce false; # causes a bunch of errors

      ly = let
        brightnessctl = getExe pkgs.brightnessctl;
      in {
        enable = false;
        x11Support = false;
        settings = {
          clear_password = true;
          vi_mode = true;
          vi_default_mode = "insert";
          brightness_down_cmd = "${brightnessctl} -q set 10%-";
          brightness_up_cmd = "${brightnessctl} -q set +10%";
          animation = "colormix"; # none, doom, matrix, colormix, gameoflife
          bigclock = "en";
          bigclock_seconds = true; # doesn't work
          clock = "%c";
        };
      };

      gdm = {
        enable = false;
        wayland = true;
        # settings = {};
      };

      # only work with gdm, sddm and lightdm iirc
      defaultSession = "niri"; # used for autoLogin
      autoLogin = {
        enable = false;
        user = "ratakor";
      };
    };

    # disable auto-installation of unneeded softwares
    xserver = {
      desktopManager.xterm.enable = false;
      displayManager.lightdm.enable = false;
    };
  };
}
