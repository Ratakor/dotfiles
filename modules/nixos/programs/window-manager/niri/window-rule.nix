# Window rules let you adjust behavior for individual windows.
# https://yalter.github.io/niri/Configuration:-Window-Rules
{ config, lib }:
let
  inherit (builtins) length elemAt;
  inherit (lib.strings) optionalString;

  dev = config.self.device;

  open-on-primary-monitor = optionalString (length dev.monitors > 0) /* kdl */ ''
    open-on-output "${(elemAt dev.monitors 0).name}"
  '';

  no-border = /* kdl */ ''
    focus-ring {
      off
    }
    border {
      off
    }
  '';
in
# kdl
''
  // Work around WezTerm's initial configure bug
  // by setting an empty default-column-width.
  /-window-rule {
    // This regular expression is intentionally made as specific as possible,
    // since this is the default config, and we want no false positives.
    // You can get away with just app-id="wezterm" if you want.
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
  }

  // Enable rounded corners for all windows
  // I'm only enabling this because chromium got weird rounded corner by default
  window-rule {
    geometry-corner-radius 8 // 12 is also decent
    clip-to-geometry true
  }

  window-rule {
    match title=r#"^Picture-in-Picture$"#
    match title=r#"^Picture in picture$"#
    open-floating true
  }

  window-rule {
    // comment to match all
    match app-id=r#"^com\.mitchellh\.ghostty$"#
    draw-border-with-background false
  }

  /-window-rule {
    match app-id=r#"^com\.mitchellh\.ghostty$"#

    background-effect {
      blur true
      // xray false
    }
  }

  // Example: block out two password managers from screen capture.
  window-rule {
    match app-id=r#"^org\.keepassxc\.KeePassXC$"#
    match app-id=r#"^org\.gnome\.World\.Secrets$"#

    block-out-from "screen-capture"

    // Use this instead if you want them visible on third-party screenshot tools.
    // block-out-from "screencast"
  }

  // https://github.com/YaLTeR/niri/issues/2153
  // https://github.com/YaLTeR/niri/discussions/2057
  /-window-rule {
    match title="^$"
    open-floating true
  }

  window-rule {
    match title="^Path of Exile$"
    match app-id="steam_app_238960"
    match title="^Path of Exile 2$"
    match app-id="steam_app_2694490"
    ${open-on-primary-monitor}
    open-fullscreen true
    // open-on-workspace "gaming"
    /*
    open-floating true
    ${no-border}
    */
  }

  window-rule {
    match app-id="awakened-poe-trade"
    /*
    open-floating true
    open-focused false
    ${no-border}
    */
  }
''
