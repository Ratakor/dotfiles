# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib) wrapWith;

  # ff = 100%
  # e6 = 90%
  # d9 = 85%
  # c0 = 75%
  opacity = {
    fg = "ff";
    bg = "c0";
  };

  colors = config.self.colors.default;

  ini = pkgs.formats.ini { };

  settings = {
    main = {
      font = "monospace:size=${toString config.self.fontSize}";
      horizontal-pad = 5;
      vertical-pad = 5;
      width = 45;
    };

    colors = rec {
      background = colors.background + opacity.bg;
      text = colors.foreground + opacity.fg;
      prompt = text;
      placeholder = colors.comment + opacity.fg;
      input = text;
      match = colors.orange + opacity.fg; # or cyan
      selection = colors.selection + opacity.bg;
      selection-text = text;
      selection-match = match;
      counter = placeholder;
      border = colors.blue + "ff";
    };

    border = {
      width = 2;
      radius = 0; # rounded doesn't look good, at least on niri
    };

    # key-bindings = {
    #   execute-input = "Return";
    # };
  };

  fuzzel = wrapWith pkgs {
    basePackage = pkgs.fuzzel;
    prependFlags = [
      "--config"
      (ini.generate "fuzzel.ini" settings)
    ];
  };
in
{
  config = mkIf (config.self.programs.menu.program == "fuzzel") {
    user.packages = [ fuzzel ];

    self.programs.menu = {
      dynamic = "fuzzel --dmenu";
      drun = "fuzzel";
      run = "fuzzel --list-executables-in-path";
    };
  };
}
