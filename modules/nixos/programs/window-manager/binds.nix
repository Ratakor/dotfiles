{ config, lib, ... }:
let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.fixedPoints) fix;

  inherit (config.hm.xdg.userDirs.extraConfig) NOTES;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  config.self.programs.windowManager.binds = fix (binds: {
    "Mod+Return" = {
      spawn = dprg.terminal.cmd;
      niri = {
        repeat = false;
        hotkey-overlay-title = "Open a terminal: ${dprg.terminal.name}";
      };
    };

    "Mod+D" = {
      spawn = dprg.launcher.drun;
      niri = {
        repeat = false;
        hotkey-overlay-title = "Run an Application: ${dprg.launcher.name}";
      };
    };
    "Mod+Shift+D" = {
      spawn = dprg.launcher.run;
      niri = {
        repeat = false;
        hotkey-overlay-title = null;
      };
    };

    # "Mod+N" = {
    #   spawn = "${dprg.terminal.cmd} -e newsboat";
    #   # spawn = "${dprg.terminal.cmd} -e zellij attach --create main";
    #   niri = {
    #     repeat = false;
    #     hotkey-overlay-title = "Open RSS feed: newsboat";
    #     # hotkey-overlay-title = "Open main Zellij session";
    #   };
    # };

    # see `dms ipc notepad toggle`
    "Mod+Shift+N" = {
      spawn = "${dprg.terminal.cmdDir} ${NOTES} -e zellij attach --create notes";
      # spawn = "${dprg.terminal.cmd} -e yazi ${NOTES}";
      niri = {
        repeat = false;
        hotkey-overlay-title = "Open notes directory in a Zellij session";
      };
    };

    "Mod+B" = {
      spawn = dprg.browser.newWindow;
      niri = {
        repeat = false;
        hotkey-overlay-title = "Open browser: ${dprg.browser.name}";
      };
    };

    "XF86Battery" = {
      spawn = "battery";
      niri = {
        repeat = false;
        hotkey-overlay-title = "Show battery information";
      };
    };

    # TODO: use wlr-which-key to handle prev/next instead?
    "Mod+Shift+W" = {
      spawn = dprg.wallpaper.nextRandom;
      niri = {
        repeat = false;
        hotkey-overlay-title = "Set a random wallpaper";
      };
    };

    # see also `dms ipc audio increment 2`, `dms ipc audio mute`, `dms ipc audio micmute`
    # TODO: -repeat on river
    # riverctl map -repeat normal None XF86AudioRaiseVolume spawn 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+'
    # riverctl map -repeat normal Super Equal spawn 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+'
    # riverctl map -repeat normal None XF86AudioLowerVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'
    # riverctl map -repeat normal Super Minus spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'
    # riverctl map normal None XF86Launch1 spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
    # riverctl map normal None F6 spawn 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'
    "XF86AudioRaiseVolume" = {
      spawn = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+";
      niri = {
        allow-when-locked = true;
        hotkey-overlay-title = null;
      };
    };
    "XF86AudioLowerVolume" = {
      spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
      niri = {
        allow-when-locked = true;
        hotkey-overlay-title = null;
      };
    };
    "XF86AudioMute" = {
      spawn = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      niri = {
        repeat = false;
        allow-when-locked = true;
        hotkey-overlay-title = null;
      };
    };
    "XF86AudioMicMute" = {
      spawn = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      niri = {
        repeat = false;
        allow-when-locked = true;
        hotkey-overlay-title = null;
      };
    };
    "Ctrl+Equal" = binds."XF86AudioRaiseVolume";
    "Ctrl+Minus" = binds."XF86AudioLowerVolume";
    "XF86Launch1" = binds."XF86AudioMute";
    "F6" = binds."XF86AudioMicMute";

    "XF86AudioPrev" = {
      spawn = "playerctl previous";
      niri = {
        repeat = false;
        allow-when-locked = true;
      };
    };
    "XF86AudioNext" = {
      spawn = "playerctl next";
      niri = {
        repeat = false;
        allow-when-locked = true;
      };
    };
    "XF86AudioPlay" = {
      spawn = "playerctl play-pause";
      niri = {
        repeat = false;
        allow-when-locked = true;
      };
    };
    "XF86AudioStop" = {
      spawn = "playerctl stop";
      niri = {
        repeat = false;
        allow-when-locked = true;
      };
    };
    "Mod+Shift+Left" = recursiveUpdate binds."XF86AudioPrev" {
      niri.hotkey-overlay-title = "Play previous track";
    };
    "Mod+Shift+Right" = recursiveUpdate binds."XF86AudioNext" {
      niri.hotkey-overlay-title = "Play next track";
    };
    "Mod+Shift+Down" = recursiveUpdate binds."XF86AudioPlay" {
      niri.hotkey-overlay-title = "Toggle playback";
    };
    "Mod+Shift+Up" = recursiveUpdate binds."XF86AudioStop" {
      niri.hotkey-overlay-title = "Stop playback";
    };

    "Mod+E" = {
      spawn = "emojisearch";
      niri = {
        repeat = false;
        hotkey-overlay-title = "Dynamically search emojis";
      };
    };

    "Mod+Shift+E" = {
      spawn = dprg.powerMenu.cmd;
      niri = {
        repeat = false;
        hotkey-overlay-title = "Exit options";
      };
    };

    "Mod+U" = {
      spawn = "plumber --dmenu \"$(wl-paste)\"";
      niri = {
        repeat = false;
        hotkey-overlay-title = "Dynamically plumb clipboard";
      };
    };
    "Mod+Shift+U" = {
      spawn = "plumber \"$(wl-paste)\"";
      niri = {
        repeat = false;
        hotkey-overlay-title = "Plumb clipboard";
      };
    };

    "Mod+Shift+B" = {
      spawn = dprg.statusBar.toggle;
      niri = {
        repeat = false;
        hotkey-overlay-title = "Toggle status bar";
      };
    };

    # //# TODO: toggle padding (gaps)
    # //#riverctl map normal Super+Shift G ...
    # //# cycle layout (toggle floating mode)
    # //# riverctl map normal Super+Shift Space spawn \
    # //# 	'killall rivertile || rivertile -view-padding 0 -outer-padding 0 -main-ratio 0.55'
    # //# TODO: toggle transparency
    # //#riverctl map normal Control P spawn 'killall picom || picom -b'

    "XF86MonBrightnessUp" = {
      spawn = "brightnessctl set +10%";
      niri = {
        allow-when-locked = true;
        hotkey-overlay-title = "Increase brightness";
      };
    };
    "XF86MonBrightnessDown" = {
      spawn = "brightnessctl set 10%-";
      niri = {
        allow-when-locked = true;
        hotkey-overlay-title = "Decrease brightness";
      };
    };
    "Mod+Insert" = recursiveUpdate binds."XF86MonBrightnessUp" { niri.hotkey-overlay-title = null; };
    "Mod+Delete" = recursiveUpdate binds."XF86MonBrightnessDown" { niri.hotkey-overlay-title = null; };

    # Mod+Shift+O might be a good bind too
    "Shift+Print" = {
      spawn = "ocr";
      niri = {
        repeat = false;
        hotkey-overlay-title = "Perform OCR on a screenshot";
      };
    };

    # "F7" = {
    #   spawn = "${dprg.terminal.cmd} -e dmenurecord";
    #   niri = {
    #     repeat = false;
    #   };
    # };
  });
}
