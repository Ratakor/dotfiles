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
  wallpapersDir = config.hm.xdg.userDirs.extraConfig.WALLPAPERS;
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
            "tray"
            "notifications"
            "clipboard"
            "recorder" # requires noctalia/screen_recorder plugin
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
            # "status" # requires icefish/phone-operate plugin
          ];
          start = [
            "launcher"
            "wallpaper"
            "wallhaven" # requires noctalia/wallhaven plugin
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
        dock = {
          # enabled = true;
          reserve_space = false;
          smart_auto_hide = true;
        };
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
        osd.kinds = {
          media = false;
          privacy = false; # idk this kinda looks bad on recordings
        };
        plugin_settings = {
          "noctalia/wallhaven" = {
            download_dir = "${wallpapersDir}/wallhaven";
            browser_placement = "floating";
          };
          "noctalia/screen_recorder" = {
            directory = "${config.hm.xdg.userDirs.videos}/recordings";
          };
        };
        plugins.enabled = [
          "noctalia/screen_recorder"
          # "noctalia/timer"
          # "noctalia/translator" # idk cool but kinda meh
          "noctalia/wallhaven"
          # "icefish/phone-operate"
        ];
        shell = {
          # avatar_path = user.avatar; # probably overkill and better be configured imperatively
          launch_apps_as_systemd_services = true;
          panel = {
            transparency_mode = "glass"; # "solid" "soft" "glass"
            wallpaper_placement = "floating";
          };
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
          directory = wallpapersDir;
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

    user.packages = with pkgs; [
      gpu-screen-recorder # needed for screen recorder plugin
    ];
  };
}
