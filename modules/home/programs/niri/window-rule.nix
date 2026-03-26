# Window rules let you adjust behavior for individual windows.
# https://yalter.github.io/niri/Configuration:-Window-Rules
let
  no-border =
    # kdl
    ''
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

  window-rule {
    match title="^Picture-in-Picture$"
    open-floating true
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
    open-on-output "DP-2"// TODO: this should be host specific
    open-fullscreen true
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
