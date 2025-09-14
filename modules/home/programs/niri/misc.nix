# https://yalter.github.io/niri/Configuration:-Miscellaneous
# vim: ft=kdl
config:
let
  inherit (config.self) colors;
  inherit (config.hm.xdg.userDirs.extraConfig) XDG_SCREENSHOTS_DIR;
in
''
  environment {
    MOZ_ENABLE_WAYLAND "1"
    NIXOS_OZONE_WAYLAND "1"
  }

  // Add lines like this to spawn processes at startup.
  // Note that running niri as a session supports xdg-desktop-autostart,
  // which may be more convenient to use.
  spawn-at-startup "randwp"
  spawn-sh-at-startup "python3 ${./niri_tile_to_n.py} -n 2"

  // Uncomment this line to ask the clients to omit their client-side decorations if possible.
  // If the client will specifically ask for CSD, the request will be honored.
  // Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
  // This option will also fix border/focus ring drawing behind some semitransparent windows.
  // After enabling or disabling this, you need to restart the apps for this to take effect.
  prefer-no-csd

  // You can change the path where screenshots are saved.
  // A ~ at the front will be expanded to the home directory.
  // The path is formatted with strftime(3) to give you the screenshot date and time.
  // screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
  screenshot-path "${XDG_SCREENSHOTS_DIR}/%Y-%m-%d_%H:%M:%S.png"

  // You can also set this to null to disable saving screenshots to disk.
  // screenshot-path null

  cursor {
    xcursor-theme "${colors.cursor.theme}"
    xcursor-size 24
    // hide-when-typing
    // hide-after-inactive-ms 1000
  }

  overview {
    zoom 0.5
    backdrop-color "#${colors.background}"
    workspace-shadow {
        // off
    }
  }

  // xwayland-satellite { }

  clipboard {
    disable-primary
  }

  hotkey-overlay {
    skip-at-startup
    // hide-not-bound
  }
''
