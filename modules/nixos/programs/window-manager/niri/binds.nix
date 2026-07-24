# https://yalter.github.io/niri/Configuration:-Key-Bindings
{ config, lib }:
let
  inherit (builtins) isInt isString typeOf;
  inherit (lib.strings)
    concatMapAttrsStringSep
    escape
    hasInfix
    optionalString
    ;

  mkValue =
    v:
    if isString v then
      "\"${v}\""
    else if true == v then
      "true"
    else if false == v then
      "false"
    else if null == v then
      "null"
    else if isInt v then
      toString v
    else
      throw "Unsupported value type: ${typeOf v}";

  prg = config.self.programs;

  dprg = prg.default;
  # niri allow only one action per keybind
  lockCmd = "${dprg.locker.cmd}; niri msg action power-off-monitors";
in
# kdl
''
  binds {
    // Keys consist of modifiers separated by + signs, followed by an XKB key name
    // in the end. To find an XKB name for a particular key, you may use a program
    // like **wev**.
    //
    // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
    // when running as a winit window.
    //
    // Most actions that you can bind here can also be invoked programmatically with
    // `niri msg action do-something`.

    // Mod-Shift-/, which is usually the same as Mod-?,
    // shows a list of important hotkeys.
    Mod+Shift+Slash { show-hotkey-overlay; }

    // Open/close the Overview: a zoomed-out view of workspaces and windows.
    // You can also move the mouse into the top-left hot corner,
    // or do a four-finger swipe up on a touchpad.
    Mod+O repeat=false { toggle-overview; }

    Mod+Shift+Q repeat=false { close-window; }

    // Mod+Left  { focus-column-left; }
    // Mod+Down  { focus-window-down; }
    // Mod+Up    { focus-window-up; }
    // Mod+Right { focus-column-right; }
    Mod+H     { focus-column-left; }
    Mod+J     { focus-window-or-workspace-down; }
    Mod+K     { focus-window-or-workspace-up; }
    Mod+L     { focus-column-right; }

    // Mod+Shift+Left  { move-column-left; }
    // Mod+Ctrl+Down  { move-window-down; }
    // Mod+Ctrl+Up    { move-window-up; }
    // Mod+Shift+Right { move-column-right; }
    Mod+Shift+H     { move-column-left; }
    Mod+Shift+J     { move-window-down-or-to-workspace-down; }
    Mod+Shift+K     { move-window-up-or-to-workspace-up; }
    Mod+Shift+L     { move-column-right; }

    Mod+Home { focus-column-first; }
    Mod+End  { focus-column-last; }
    Mod+Shift+Home { move-column-to-first; }
    Mod+Shift+End  { move-column-to-last; }

    // Mod+Ctrl+Left  { focus-monitor-left; }
    // Mod+Ctrl+Down  { focus-monitor-down; }
    // Mod+Ctrl+Up    { focus-monitor-up; }
    // Mod+Ctrl+Right { focus-monitor-right; }
    Mod+Ctrl+H     { focus-monitor-left; }
    Mod+Ctrl+J     { focus-monitor-down; }
    Mod+Ctrl+K     { focus-monitor-up; }
    Mod+Ctrl+L     { focus-monitor-right; }
    // Mod+Comma      { focus-monitor-left; }
    // Mod+Period     { focus-monitor-right; }

    // Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
    // Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
    // Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
    // Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
    Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
    Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
    Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
    Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
    // Mod+Shift+Comma      { move-column-to-monitor-left; }
    // Mod+Shift+Period     { move-column-to-monitor-right; }

    // Alternatively, there are commands to move just a single window:
    // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
    // ...

    // And you can also move a whole workspace to another monitor:
    // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
    // ...

    Mod+Page_Down      { focus-workspace-down; }
    Mod+Page_Up        { focus-workspace-up; }
    // Mod+U              { focus-workspace-down; }
    // Mod+I              { focus-workspace-up; }
    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
    Mod+Ctrl+U         { move-column-to-workspace-down; }
    Mod+Ctrl+I         { move-column-to-workspace-up; }

    // Alternatively, there are commands to move just a single window:
    // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
    // ...

    Mod+Shift+Page_Down { move-workspace-down; }
    Mod+Shift+Page_Up   { move-workspace-up; }
    // Mod+Shift+U         { move-workspace-down; }
    // Mod+Shift+I         { move-workspace-up; }

    // TODO: config mouse
    // MouseLeft MouseRight MouseMiddle MouseBack MouseForward
    // These bindings don't exist see
    // https://github.com/YaLTeR/niri/discussions/2383
    //Mod+MouseLeft { move-window; }
    //Mod+Shift+MouseLeft { resize-window; }
    //Mod+MouseRight { window-resize; }

    // You can bind mouse wheel scroll ticks using the following syntax.
    // These binds will change direction based on the natural-scroll setting.
    //
    // To avoid scrolling through workspaces really fast, you can use
    // the cooldown-ms property. The bind will be rate-limited to this value.
    // You can set a cooldown on any bind, but it's most useful for the wheel.
    Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
    Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
    Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
    Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

    Mod+WheelScrollRight      { focus-column-right; }
    Mod+WheelScrollLeft       { focus-column-left; }
    Mod+Ctrl+WheelScrollRight { move-column-right; }
    Mod+Ctrl+WheelScrollLeft  { move-column-left; }

    // Usually scrolling up and down with Shift in applications results in
    // horizontal scrolling; these binds replicate that.
    Mod+Shift+WheelScrollDown      { focus-column-right; }
    Mod+Shift+WheelScrollUp        { focus-column-left; }
    Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
    Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

    // Similarly, you can bind touchpad scroll "ticks".
    // Touchpad scrolling is continuous, so for these binds it is split into
    // discrete intervals.
    // These binds are also affected by touchpad's natural-scroll, so these
    // example binds are "inverted", since we have natural-scroll enabled for
    // touchpads by default.
    Mod+TouchpadScrollDown      cooldown-ms=150 { focus-workspace-down; }
    Mod+TouchpadScrollUp        cooldown-ms=150 { focus-workspace-up; }
    Mod+Ctrl+TouchpadScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
    Mod+Ctrl+TouchpadScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

    Mod+TouchpadScrollRight      cooldown-ms=150 { focus-column-right; }
    Mod+TouchpadScrollLeft       cooldown-ms=150 { focus-column-left; }
    Mod+Ctrl+TouchpadScrollRight cooldown-ms=150 { move-column-right; }
    Mod+Ctrl+TouchpadScrollLeft  cooldown-ms=150 { move-column-left; }

    // You can refer to workspaces by index. However, keep in mind that
    // niri is a dynamic workspace system, so these commands are kind of
    // "best effort". Trying to refer to a workspace index bigger than
    // the current workspace count will instead refer to the bottommost
    // (empty) workspace.
    //
    // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
    // will all refer to the 3rd workspace.
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }
    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }
    Mod+Shift+6 { move-column-to-workspace 6; }
    Mod+Shift+7 { move-column-to-workspace 7; }
    Mod+Shift+8 { move-column-to-workspace 8; }
    Mod+Shift+9 { move-column-to-workspace 9; }

    // Alternatively, there are commands to move just a single window:
    // Mod+Ctrl+1 { move-window-to-workspace 1; }

    // Switches focus between the current and the previous workspace.
    // Mod+Tab { focus-workspace-previous; }

    // The following binds move the focused window in and out of a column.
    // If the window is alone, they will consume it into the nearby column to the side.
    // If the window is already in a column, they will expel it out.
    Mod+BracketLeft  { consume-or-expel-window-left; }
    Mod+BracketRight { consume-or-expel-window-right; }

    // Consume one window from the right to the bottom of the focused column.
    Mod+Comma  { consume-window-into-column; }
    // Expel the bottom window from the focused column to the right.
    Mod+Period { expel-window-from-column; }

    Mod+R { switch-preset-column-width; }
    Mod+Shift+R { switch-preset-window-height; }
    Mod+Ctrl+R { reset-window-height; }
    Mod+F { maximize-column; }
    Mod+Shift+F { fullscreen-window; }

    // Expand the focused column to space not taken up by other fully visible columns.
    // Makes the column "fill the rest of the space".
    Mod+Ctrl+F { expand-column-to-available-width; }

    Mod+C { center-column; }

    // Center all fully visible columns on screen.
    Mod+Ctrl+C { center-visible-columns; }

    // Finer width adjustments.
    // This command can also:
    // * set width in pixels: "1000"
    // * adjust width in pixels: "-5" or "+5"
    // * set width as a percentage of screen width: "25%"
    // * adjust width as a percentage of screen width: "-10%" or "+10%"
    // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
    // set-column-width "100" will make the column occupy 200 physical screen pixels.
    Mod+Minus { set-column-width "-10%"; }
    Mod+Equal { set-column-width "+10%"; }

    // Finer height adjustments when in column with other windows.
    Mod+Shift+Minus { set-window-height "-10%"; }
    Mod+Shift+Equal { set-window-height "+10%"; }

    // Move the focused window between the floating and the tiling layout.
    Mod+Space       { toggle-window-floating; }
    Mod+Shift+Space { switch-focus-between-floating-and-tiling; }
    //Mod+V       { toggle-window-floating; }
    //Mod+Shift+V { switch-focus-between-floating-and-tiling; }

    // Toggle tabbed column display mode.
    // Windows in this column will appear as vertical tabs,
    // rather than stacked on top of each other.
    Mod+T { toggle-column-tabbed-display; }

    // Actions to switch layouts.
    // Note: if you uncomment these, make sure you do NOT have
    // a matching layout switch hotkey configured in xkb options above.
    // Having both at once on the same hotkey will break the switching,
    // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
    // Mod+Space       { switch-layout "next"; }
    // Mod+Shift+Space { switch-layout "prev"; }

    // Applications such as remote-desktop clients and software KVM switches may
    // request that niri stops processing the keyboard shortcuts defined here
    // so they may, for example, forward the key presses as-is to a remote machine.
    // It's a good idea to bind an escape hatch to toggle the inhibitor,
    // so a buggy application can't hold your session hostage.
    //
    // The allow-inhibiting=false property can be applied to other binds as well,
    // which ensures niri always processes them, even when an inhibitor is active.
    Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

    // The quit action will show a confirmation dialog to avoid accidental exits.
    // Mod+Shift+E { quit; }
    Ctrl+Alt+Delete { quit; }

    // Powers off the monitors. To turn them back on, do any input like
    // moving the mouse or pressing any other key.
    Mod+Shift+P hotkey-overlay-title="Power off monitors" { power-off-monitors; }

    Print { screenshot show-pointer=false; }
    Ctrl+Print { screenshot-screen show-pointer=false; }
    Alt+Print { screenshot-window show-pointer=false; }

    // TODO: move to prg.windowManager.binds
    // depends on https://github.com/niri-wm/niri/pull/3192
    Mod+Shift+X repeat=false hotkey-overlay-title="Lock the Screen: ${dprg.locker.name}" { spawn-sh "${lockCmd}"; }
    XF86ScreenSaver repeat=false { spawn-sh "${lockCmd}"; }

    ${concatMapAttrsStringSep "\n" (
      name: value:
      ''${name} ${
        concatMapAttrsStringSep " " (k: v: "${k}=${mkValue v}") value.niri
      } { spawn${optionalString (hasInfix " " value.spawn) "-sh"} "${escape [ "\"" ] value.spawn}"; }''
    ) prg.windowManager.binds}
  }
''
