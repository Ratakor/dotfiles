# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  wlib,
  ...
}:
let
  inherit (lib.modules) mkIf;

  colors = config.self.colors.default;
  prg = config.self.programs;

  # ff = 100%
  # e6 = 90%
  # d9 = 85%
  # c0 = 75%
  opacity = {
    fg = "ff";
    bg = "c0";
  };

  # there is a module way to do that but it sucks
  # so let's build a package everytime instead
  # actually a lot of nix-wrapper-modules sucks,
  # like the options directly in flake
  # or the big boilerplate,
  # but it's alright the rest looks solid
  package = wlib.evalPackage {
    inherit pkgs;
    imports = [ wlib.wrapperModules.fuzzel ];
    settings = {
      main = {
        font = "monospace:size=${toString prg.terminal.fontSize}";
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
  };
in
{
  config = mkIf prg.launcher.fuzzel.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "fuzzel") {
      dmenu = "fuzzel --dmenu";
      drun = "fuzzel";
      run = "fuzzel --list-executables-in-path";
    };

    user.packages = [ package ];
  };
}
