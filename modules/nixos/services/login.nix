# TODO: need configuration:
# - config.login.autologin = { enable, user, command }
# - config.login.manager
# https://kl.wtf/posts/2022/03/12/login-managers-an-introduction.html
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.meta) getExe;
in
{
  services = {
    getty = mkIf false {
      autologinOnce = true;
      autologinUser = config.self.user.name;
    };

    greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        vt = 1;

        # autologin
        initial_session = {
          command = config.self.programs.default.windowManager.cmd;
          user = config.self.user.name;
        };

        # fallback
        default_session = {
          command = concatStringsSep " " [
            (getExe pkgs.tuigreet)
            "--time"
            "--asterisks"
            "--remember"
            # "--remember-user-session" # I'm pretty sure this doesn't work
            "--remember-session"
            # "--cmd 'zsh'"
          ];
          user = "greeter";
        };
      };
    };

    displayManager = {
      # enable = lib.mkForce false; # causes a bunch of errors

      # doesn't seem to work
      dms-greeter = {
        enable = false;
        compositor.name = "niri";
      };

      ly =
        let
          brightnessctl = getExe pkgs.brightnessctl;
        in
        {
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
        user = config.self.user.name;
      };
    };

    # disable auto-installation of unneeded software
    xserver = {
      desktopManager.xterm.enable = mkForce false;
      displayManager.lightdm.enable = mkForce false;
      excludePackages = [ pkgs.xterm ];
    };
  };
}
