# Wayland Terminal Emulator
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.self) colors;

  prg = config.self.programs;

  settings = {
    main = {
      font = "monospace:size=${toString prg.terminal.fontSize}";
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
      foreground = colors.alternative.foreground;
      background = colors.alternative.background;
      cursor = "${colors.alternative.background} ${colors.alternative.foreground}";
      selection-background = colors.alternative.selection;

      regular0 = colors.alternative.black;
      regular1 = colors.alternative.red;
      regular2 = colors.alternative.green;
      regular3 = colors.alternative.yellow;
      regular4 = colors.alternative.blue;
      regular5 = colors.alternative.magenta;
      regular6 = colors.alternative.cyan;
      regular7 = colors.alternative.white;

      bright0 = colors.alternative.bright.black;
      bright1 = colors.alternative.bright.red;
      bright2 = colors.alternative.bright.green;
      bright3 = colors.alternative.bright.yellow;
      bright4 = colors.alternative.bright.blue;
      bright5 = colors.alternative.bright.magenta;
      bright6 = colors.alternative.bright.cyan;
      bright7 = colors.alternative.bright.white;
    };

    colors-dark = {
      alpha = "0.85";
      foreground = colors.default.foreground;
      background = colors.default.background;
      cursor = "${colors.default.background} ${colors.default.foreground}";
      selection-background = colors.default.selection;

      regular0 = colors.default.black;
      regular1 = colors.default.red;
      regular2 = colors.default.green;
      regular3 = colors.default.yellow;
      regular4 = colors.default.blue;
      regular5 = colors.default.magenta;
      regular6 = colors.default.cyan;
      regular7 = colors.default.white;

      bright0 = colors.default.bright.black;
      bright1 = colors.default.bright.red;
      bright2 = colors.default.bright.green;
      bright3 = colors.default.bright.yellow;
      bright4 = colors.default.bright.blue;
      bright5 = colors.default.bright.magenta;
      bright6 = colors.default.bright.cyan;
      bright7 = colors.default.bright.white;
    };
  };
in
{
  config = mkIf prg.terminal.foot.enable {
    self.programs.default.terminal = mkIf (prg.default.terminal.name == "foot") {
      cmd = "footclient";
      cmdDir = "footclient -D";
    };

    hm.programs.foot = {
      enable = true;
      server.enable = true;
      inherit settings;
    };
  };
}
