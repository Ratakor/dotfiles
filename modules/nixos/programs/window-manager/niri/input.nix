# Input device configuration.
# https://yalter.github.io/niri/Configuration:-Input
{ config, ... }:
let
  inherit (config.self.system) keyboard;
in
# kdl
''
  input {
    keyboard {
      xkb {
        layout "${keyboard.layout}"
        variant "${keyboard.variant}"
        options "${keyboard.options}"
      }

      repeat-delay 300
      repeat-rate 50
      // numlock // Enable numlock on startup
    }

    // Next sections include libinput settings.
    // Omitting settings disables them, or leaves them at their default values.
    touchpad {
      // off
      tap
      // dwt
      // dwtp
      // drag false
      // drag-lock
      natural-scroll
      // accel-speed 0.2
      // accel-profile "flat"
      // scroll-method "two-finger"
      // disabled-on-external-mouse
    }

    mouse {
      accel-speed 0.0
      accel-profile "flat" // disable pointer acceleration
    }

    trackpoint {
      // off
      // natural-scroll
      // accel-speed 0.2
      // accel-profile "flat"
      // scroll-method "on-button-down"
      // scroll-button 273
      // middle-emulation
    }

    // disable-power-key-handling
    // warp-mouse-to-focus
    focus-follows-mouse max-scroll-amount="0%"
    // workspace-auto-back-and-forth
    mod-key "Super"
    mod-key-nested "Alt"
  }
''
