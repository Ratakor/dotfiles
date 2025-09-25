# Based on dracula theme, looks alright and I cba configuring more.
# I think the first color is for light theme.
{ config, pkgs, ... }:
let
  inherit (config.self) colors;
in
pkgs.ankiAddons.recolor.withConfig {
  config = {
    colors = {
      ACCENT_CARD = [
        "Card mode"
        "#60a5fa"
        "#93c5fd"
        "--accent-card"
      ];
      ACCENT_DANGER = [
        "Danger"
        "#ef4444"
        "#f87171"
        "--accent-danger"
      ];
      ACCENT_NOTE = [
        "Note mode"
        "#22c55e"
        "#4ade80"
        "--accent-note"
      ];
      BORDER = [
        "Border"
        "#c4c4c4"
        "#${colors.blue}"
        "--border"
      ];
      BORDER_FOCUS = [
        "Border (focused input)"
        "#3b82f6"
        "#3b82f6"
        "--border-focus"
      ];
      BORDER_STRONG = [
        "Border (strong)"
        "#858585"
        "#020202"
        "--border-strong"
      ];
      BORDER_SUBTLE = [
        "Border (subtle)"
        "#e4e4e4"
        "#${colors.unfocused}"
        "--border-subtle"
      ];
      BUTTON_BG = [
        "Button background"
        "white"
        "#${colors.unfocused}"
        "--button-bg"
      ];
      BUTTON_DISABLED = [
        "Button background (disabled)"
        "#d6d6d680"
        "#45454580"
        "--button-disabled"
      ];
      BUTTON_HOVER = [
        "Button background (hover)"
        "#f4f4f4"
        "#${colors.selection}"
        [
          "--button-gradient-start"
          "--button-gradient-end"
        ]
      ];
      BUTTON_HOVER_BORDER = [
        "Button border (hover)"
        "#999999"
        "#141414"
        "--button-hover-border"
      ];
      BUTTON_PRIMARY_BG = [
        "Button Primary Bg"
        "#60a5fa"
        "#2f67e1"
        "--button-primary-bg"
      ];
      BUTTON_PRIMARY_DISABLED = [
        "Button Primary Disabled"
        "#93c5fd"
        "#4484ed"
        "--button-primary-disabled"
      ];
      BUTTON_PRIMARY_GRADIENT_END = [
        "Button Primary Gradient End"
        "#2563eb"
        "#2544a8"
        "--button-primary-gradient-end"
      ];
      BUTTON_PRIMARY_GRADIENT_START = [
        "Button Primary Gradient Start"
        "#60a5fa"
        "#2f67e1"
        "--button-primary-gradient-start"
      ];
      CANVAS = [
        "Background"
        "#f5f5f5"
        "#${colors.background}"
        [
          "--canvas"
          "--bs-body-bg"
        ]
      ];
      CANVAS_CODE = [
        "Code editor background"
        "white"
        "#252525"
        "--canvas-code"
      ];
      CANVAS_ELEVATED = [
        "Background (elevated)"
        "white"
        "#${colors.unfocused}"
        "--canvas-elevated"
      ];
      CANVAS_GLASS = [
        "Background (transparent text surface)"
        "#ffffff66"
        "#${colors.unfocused}66"
        "--canvas-glass"
      ];
      CANVAS_INSET = [
        "Background (inset)"
        "#eeeeee"
        "#${colors.unfocused}"
        "--canvas-inset"
      ];
      CANVAS_OVERLAY = [
        "Background (menu & tooltip)"
        "#fcfcfc"
        "#${colors.background}"
        "--canvas-overlay"
      ];
      FG = [
        "Text"
        "#020202"
        "#${colors.foreground}"
        [
          "--fg"
          "--bs-body-color"
        ]
      ];
      FG_DISABLED = [
        "Text (disabled)"
        "#858585"
        "#${colors.bright_black}"
        "--fg-disabled"
      ];
      FG_FAINT = [
        "Text (faint)"
        "#afafaf"
        "#${colors.bright_black}"
        "--fg-faint"
      ];
      FG_LINK = [
        "Text (link)"
        "#1d4ed8"
        "#${colors.cyan}"
        "--fg-link"
      ];
      FG_SUBTLE = [
        "Text (subtle)"
        "#737373"
        "#${colors.bright_black}"
        "--fg-subtle"
      ];
      FLAG_1 = [
        "Flag 1"
        "#ef4444"
        "#${colors.bright_red}"
        "--flag-1"
      ];
      FLAG_2 = [
        "Flag 2"
        "#fb923c"
        "#${colors.bright_orange}"
        "--flag-2"
      ];
      FLAG_3 = [
        "Flag 3"
        "#4ade80"
        "#${colors.bright_green}"
        "--flag-3"
      ];
      FLAG_4 = [
        "Flag 4"
        "#3b82f6"
        "#${colors.bright_blue}"
        "--flag-4"
      ];
      FLAG_5 = [
        "Flag 5"
        "#e879f9"
        "#${colors.bright_magenta}"
        "--flag-5"
      ];
      FLAG_6 = [
        "Flag 6"
        "#2dd4bf"
        "#${colors.bright_cyan}"
        "--flag-6"
      ];
      FLAG_7 = [
        "Flag 7"
        "#a855f7"
        "#${colors.magenta}"
        "--flag-7"
      ];
      HIGHLIGHT_BG = [
        "Highlight background"
        "#2563eb80"
        "#${colors.blue}" # smh magenta on dracula theme
        "--highlight-bg"
      ];
      HIGHLIGHT_FG = [
        "Highlight text"
        "black"
        "#${colors.foreground}"
        "--highlight-fg"
      ];
      SCROLLBAR_BG = [
        "Scrollbar background"
        "#d6d6d6"
        "#363636"
        "--scrollbar-bg"
      ];
      SCROLLBAR_BG_ACTIVE = [
        "Scrollbar background (active)"
        "#afafaf"
        "#636363"
        "--scrollbar-bg-active"
      ];
      SCROLLBAR_BG_HOVER = [
        "Scrollbar background (hover)"
        "#c4c4c4"
        "#454545"
        "--scrollbar-bg-hover"
      ];
      SELECTED_BG = [
        "Selected Bg"
        "#d6d6d680"
        "#93c5fd80"
        "--selected-bg"
      ];
      SELECTED_FG = [
        "Selected Fg"
        "black"
        "white"
        "--selected-fg"
      ];
      SHADOW = [
        "Shadow"
        "#c4c4c4"
        "#202020"
        "--shadow"
      ];
      SHADOW_FOCUS = [
        "Shadow (focused input)"
        "#6366f1"
        "#6366f1"
        "--shadow-focus"
      ];
      SHADOW_INSET = [
        "Shadow (inset)"
        "#454545"
        "#202020"
        "--shadow-inset"
      ];
      SHADOW_SUBTLE = [
        "Shadow (subtle)"
        "#737373"
        "#363636"
        "--shadow-subtle"
      ];
      STATE_BURIED = [
        "Buried"
        "#f59e0b"
        "#79740e" # "#92400e"
        "--state-buried"
      ];
      STATE_LEARN = [
        "Learn"
        "#dc2626"
        "#${colors.orange}"
        "--state-learn"
      ];
      STATE_MARKED = [
        "Marked"
        "#c7d2fe"
        "#${colors.blue}"
        "--state-marked"
      ];
      STATE_NEW = [
        "New"
        "#3b82f6"
        "#${colors.cyan}"
        "--state-new"
      ];
      STATE_REVIEW = [
        "Review"
        "#16a34a"
        "#${colors.green}"
        "--state-review"
      ];
      STATE_SUSPENDED = [
        "Suspended"
        "#facc15"
        "#${colors.bright_black}"
        "--state-suspended"
      ];
    };
    version = {
      major = 3;
      minor = 1;
    };
  };
}
