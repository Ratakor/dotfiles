# Wayland Terminal Emulator
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.self) colors font-size;

  settings = {
    main = {
      font = "monospace:size=${toString font-size}";
      pad = "5x5";
      # dpi-aware = "yes";
    };

    url = {
      launch = "plumber --url \${url}";
    };

    scrollback = {
      lines = 5000;
    };

    key-bindings = {
      unicode-input = "none";
      show-urls-launch = "Control+Shift+l";
      show-urls-copy = "Control+Shift+u";
      search-start = "Mod1+Shift+s";

      scrollback-up-half-page = "Mod1+u";
      scrollback-down-half-page = "Mod1+d";
      scrollback-up-line = "Mod1+k";
      scrollback-down-line = "Mod1+j";
      clipboard-copy = "Control+Shift+c";
      clipboard-paste = "Control+Shift+v";
      primary-paste = "Shift+Insert";
      font-increase = "Control+Shift+plus";
      font-decrease = "Control+Shift+minus";
      font-reset = "Control+equal";
      #pipe-selected = "[xargs -r firefox] none";
    };

    search-bindings = {
      find-prev = "Control+Shift+n";
      find-next = "Control+n";
    };

    mouse-bindings = {
      primary-paste = "none";
    };

    colors-light = {
      alpha = "0.85";
      foreground = colors.alt.foreground;
      background = colors.alt.background;
      cursor = "${colors.alt.background} ${colors.alt.foreground}";
      selection-background = colors.alt.selection;

      regular0 = colors.alt.black;
      regular1 = colors.alt.red;
      regular2 = colors.alt.green;
      regular3 = colors.alt.yellow;
      regular4 = colors.alt.blue;
      regular5 = colors.alt.magenta;
      regular6 = colors.alt.cyan;
      regular7 = colors.alt.white;

      bright0 = colors.alt.bright_black;
      bright1 = colors.alt.bright_red;
      bright2 = colors.alt.bright_green;
      bright3 = colors.alt.bright_yellow;
      bright4 = colors.alt.bright_blue;
      bright5 = colors.alt.bright_magenta;
      bright6 = colors.alt.bright_cyan;
      bright7 = colors.alt.bright_white;
    };

    colors-dark = {
      alpha = "0.85";
      foreground = colors.foreground;
      background = colors.background;
      cursor = "${colors.background} ${colors.foreground}";
      selection-background = colors.selection;

      regular0 = colors.black;
      regular1 = colors.red;
      regular2 = colors.green;
      regular3 = colors.yellow;
      regular4 = colors.blue;
      regular5 = colors.magenta;
      regular6 = colors.cyan;
      regular7 = colors.white;

      bright0 = colors.bright_black;
      bright1 = colors.bright_red;
      bright2 = colors.bright_green;
      bright3 = colors.bright_yellow;
      bright4 = colors.bright_blue;
      bright5 = colors.bright_magenta;
      bright6 = colors.bright_cyan;
      bright7 = colors.bright_white;
    };
  };
in
{
  config = mkIf (config.self.terminal.program == "foot") {
    hm.programs.foot = {
      enable = true;
      server.enable = true;
      inherit settings;
    };

    self.terminal = {
      cmd = "footclient";
      cmdDir = "footclient -D";
    };
  };
}
