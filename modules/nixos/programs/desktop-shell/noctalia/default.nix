{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  defaultName = "noctalia";

  inherit (config.self) colors;
  prg = config.self.programs;
  dprg = prg.default;
  XDG_CACHE_HOME = config.hm.xdg.cacheHome;
  isDefaultBar = dprg.statusBar.name == defaultName;
  isDefaultLauncher = dprg.launcher.name == defaultName;
  isDefaultWallpaper = dprg.wallpaper.name == defaultName;
  enableFootZshIntegration = dprg.terminal.name == "foot";
in
{
  config = mkIf prg.desktopShell.noctalia.enable {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "noctalia msg bar-toggle";
      };
      locker = mkIf (dprg.locker.name == defaultName) {
        cmd = "noctalia msg session lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == defaultName) {
        cmd = "noctalia msg panel-toggle session";
        # cmd = "noctalia msg panel-toggle launcher '/session '";
      };
      launcher = mkIf isDefaultLauncher {
        cmd = "noctalia msg panel-toggle launcher";
        emoji = "noctalia msg panel-toggle launcher '/emo '";
      };
      wallpaper = mkIf isDefaultWallpaper {
        nextRandom = "noctalia msg wallpaper-random";
        set = "noctalia msg wallpaper-set";
        get = "noctalia msg wallpaper-get";
      };
    };

    hm.imports = [ sources.noctalia.homeModules.default ];

    hm.programs.noctalia = {
      enable = true;
      systemd.enable = isDefaultBar;
      # package = pkgs.noctalia-shell;

      # imagine writing toml lmao eval time go brr
      settings = {
        bar.default = {
          center = [
            "media"
            "clock"
            "weather"
          ];
          end = [
            "tray "
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
          ];
          start = [
            "launcher"
            "wallpaper"
            "workspaces"
            "active_window"
          ];
          # dead_zone = mkIf prg.windowManager.niri.enable {
          #   scroll_down_command = "niri msg action focus-workspace-down";
          #   scroll_up_command = "niri msg action focus-workspace-up";
          # };
        };
        battery.warning_threshold = 15;
        calendar.enabled = true;
        hooks = {
          colors_changed = ./hooks/colors_changed.sh;
        };
        location.auto_locate = true;
        lockscreen.blurred_desktop = true;
        notification.enable_daemon = dprg.notification.name == defaultName; # should we use prg?
        nightlight = {
          # same config as gammastep and I'm think about prg.nightLight, the madness never ends
          enabled = false;
          temperature_day = 6000;
          temperature_night = 3000;
        };
        # plugins.enabled = [ ];
        shell = {
          # avatar_path = user.avatar; # probably overkill and better be configured imperatively
          launch_apps_as_systemd_services = true;
          panel.transparency_mode = "solid"; # "soft" and "glass" doesn't look that good, maybe need blur
        };
        theme = {
          mode = colors.variant; # "light" "dark" "auto"
          source = "builtin"; # "builtin" "wallpaper" "community" "custom"
          builtin = colors.default.noctalia.theme;
          wallpaper_scheme = "faithful";
          templates = {
            builtin_ids = [
              "gtk3"
              "gtk4"
              "kcolorscheme" # there is also "qt" but I don't think it's needed
              "niri"
              "ghostty"
              "helix"
            ];
            user = {
              # https://docs.noctalia.dev/v5/templates/community/terminal-templates/
              terminal-sequences = mkIf enableFootZshIntegration {
                input_path = ./templates/terminal-sequences;
                output_path = "${XDG_CACHE_HOME}/noctalia/terminal-sequences";
                post_hook = "tee /dev/pts/[0-9]* < ${XDG_CACHE_HOME}/noctalia/terminal-sequences";
              };
            };
          };
        };
        wallpaper = {
          enabled = isDefaultWallpaper;
          directory = config.hm.xdg.userDirs.extraConfig.WALLPAPERS;
          transition = [ ];
          automation = {
            enabled = true;
            interval_seconds = 30 * 60;
          };
        };
        backdrop.enabled = true; # niri stuff, this makes changing wallpaper kinda slow, at least on X200
        widget = {
          media = {
            album_art_only = true;
            hide_when_no_media = true;
          };
          wallpaper.enabled = false;
          workspaces.labels_only_when_occupied = true;
        };
      };
    };

    hm.programs.zsh.initContent = mkIf enableFootZshIntegration /* zsh */ ''
      [ -f "${XDG_CACHE_HOME}/noctalia/terminal-sequences" ] && cat "${XDG_CACHE_HOME}/noctalia/terminal-sequences"
    '';
  };
}
