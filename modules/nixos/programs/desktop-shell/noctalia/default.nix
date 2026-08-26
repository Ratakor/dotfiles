{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) optionalString;

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
        # there is "noctalia dmenu" omg!!
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
      package = pkgs.noctalia; # pkgs.noctalia-shell;

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
          colors_changed = pkgs.writeShellScript "noctalia_colors_changed.sh" ''
            ${optionalString prg.editor.helix.enableNoctaliaIntegration "kill -USR1 $(pidof hx)"}
          '';
        };
        location = {
          auto_locate = config.location.provider == "geoclue2";
          inherit (config.location) latitude longitude;
        };
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
          panel.transparency_mode = "glass"; # "solid" "soft" "glass"
        };
        theme = {
          mode = colors.variant; # "light" "dark" "auto"
          source = "wallpaper"; # "builtin" "wallpaper" "community" "custom"
          builtin = colors.default.noctalia.theme;
          wallpaper_scheme = "vibrant"; # "faithful" is also good
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
          wallpaper.enabled = isDefaultWallpaper;
          workspaces.labels_only_when_occupied = true;
        };
      };
    };

    hm.programs.zsh.initContent = mkIf enableFootZshIntegration /* zsh */ ''
      [ -f "${XDG_CACHE_HOME}/noctalia/terminal-sequences" ] && cat "${XDG_CACHE_HOME}/noctalia/terminal-sequences"
    '';
  };
}
