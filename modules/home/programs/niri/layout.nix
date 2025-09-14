# https://yalter.github.io/niri/Configuration:-Layout
# vim: ft=kdl
config:
let
  inherit (config.self) colors;
in
''
  layout {
    // Set gaps around windows in logical pixels.
    gaps 10

    // When to center a column when changing focus, options are:
    // - "never", default behavior, focusing an off-screen column will keep at the left
    //   or right edge of the screen.
    // - "always", the focused column will always be centered.
    // - "on-overflow", focusing a column will center it if it doesn't fit
    //   together with the previously focused column.
    center-focused-column "never"
    // always-center-single-column
    // empty-workspace-above-first
    // default-column-display "tabbed" // what?

    // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
    preset-column-widths {
      // Proportion sets the width as a fraction of the output width, taking gaps into account.
      // For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
      // The default preset widths are 1/3, 1/2 and 2/3 of the output.
      proportion 0.33333
      proportion 0.5
      proportion 0.66667

      // Fixed sets the width in logical pixels exactly.
      // fixed 1920
    }

    // You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
    preset-window-heights {
      proportion 0.33333
      proportion 0.5
      proportion 0.66667
      proportion 1.0
    }

    // You can change the default width of the new windows.
    default-column-width { proportion 0.5; }
    // If you leave the brackets empty, the windows themselves will decide their initial width.
    // default-column-width {}

    // By default focus ring and border are rendered as a solid background rectangle
    // behind windows. That is, they will show up through semitransparent windows.
    // This is because windows using client-side decorations can have an arbitrary shape.
    //
    // If you don't like that, you should uncomment `prefer-no-csd` below.
    // Niri will draw focus ring and border *around* windows that agree to omit their
    // client-side decorations.
    //
    // Alternatively, you can override it with a window rule called
    // `draw-border-with-background`.

    background-color "#${colors.background}"

    // border {
    focus-ring {
      width 2
      active-color "#${colors.blue}"
      inactive-color "#${colors.unfocused}"
      urgent-color "#${colors.red}"
    }

    // You can enable drop shadows for windows.
    shadow {
      // Uncomment the next line to enable shadows.
      // on

      // By default, the shadow draws only around its window, and not behind it.
      // Uncomment this setting to make the shadow draw behind its window.
      //
      // Note that niri has no way of knowing about the CSD window corner
      // radius. It has to assume that windows have square corners, leading to
      // shadow artifacts inside the CSD rounded corners. This setting fixes
      // those artifacts.
      //
      // However, instead you may want to set prefer-no-csd and/or
      // geometry-corner-radius. Then, niri will know the corner radius and
      // draw the shadow correctly, without having to draw it behind the
      // window. These will also remove client-side shadows if the window
      // draws any.
      //
      // draw-behind-window true

      // You can change how shadows look. The values below are in logical
      // pixels and match the CSS box-shadow properties.

      // Softness controls the shadow blur radius.
      softness 30

      // Spread expands the shadow.
      spread 5

      // Offset moves the shadow relative to the window.
      offset x=0 y=5

      // You can also change the shadow color and opacity.
      color "#0007"
    }

    // Struts shrink the area occupied by windows, similarly to layer-shell panels.
    // You can think of them as a kind of outer gaps. They are set in logical pixels.
    // Left and right struts will cause the next window to the side to always be visible.
    // Top and bottom struts will simply add outer gaps in addition to the area occupied by
    // layer-shell panels and regular gaps.
    struts {
      // left 64
      // right 64
      // top 64
      // bottom 64
    }
  }
''
