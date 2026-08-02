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
  isDefault = prg.default.terminal.name == "foot";

  settings = {
    main = {
      font = "monospace:size=${toString prg.terminal.fontSize}";
      pad = "5x5";
      # dpi-aware = "yes";
      initial-color-theme = colors.variant;
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
      foreground = colors.light.foreground;
      background = colors.light.background;
      cursor = "${colors.light.background} ${colors.light.cursor or colors.light.foreground}";
      selection-background = colors.light.selection;

      regular0 = colors.light.black;
      regular1 = colors.light.red;
      regular2 = colors.light.green;
      regular3 = colors.light.yellow;
      regular4 = colors.light.blue;
      regular5 = colors.light.magenta;
      regular6 = colors.light.cyan;
      regular7 = colors.light.white;

      bright0 = colors.light.bright.black;
      bright1 = colors.light.bright.red;
      bright2 = colors.light.bright.green;
      bright3 = colors.light.bright.yellow;
      bright4 = colors.light.bright.blue;
      bright5 = colors.light.bright.magenta;
      bright6 = colors.light.bright.cyan;
      bright7 = colors.light.bright.white;
    };

    colors-dark = {
      alpha = "0.85";
      foreground = colors.dark.foreground;
      background = colors.dark.background;
      cursor = "${colors.dark.background} ${colors.dark.cursor or colors.dark.foreground}";
      selection-background = colors.dark.selection;

      regular0 = colors.dark.black;
      regular1 = colors.dark.red;
      regular2 = colors.dark.green;
      regular3 = colors.dark.yellow;
      regular4 = colors.dark.blue;
      regular5 = colors.dark.magenta;
      regular6 = colors.dark.cyan;
      regular7 = colors.dark.white;

      bright0 = colors.dark.bright.black;
      bright1 = colors.dark.bright.red;
      bright2 = colors.dark.bright.green;
      bright3 = colors.dark.bright.yellow;
      bright4 = colors.dark.bright.blue;
      bright5 = colors.dark.bright.magenta;
      bright6 = colors.dark.bright.cyan;
      bright7 = colors.dark.bright.white;
    };
  };
in
{
  config = mkIf prg.terminal.foot.enable {
    self.programs.default.terminal = mkIf isDefault {
      cmd = "footclient";
      cmdDir = "footclient -D";
    };

    hm.programs.foot = {
      enable = true;
      server.enable = isDefault;
      inherit settings;
    };

    # we should really write a foot wrapper + NixOS systemd service instead of
    # using home-manager :D
    hm.systemd.user.services.foot = mkIf isDefault {
      Unit.X-SwitchMethod = "keep-old";
    };
  };
}
