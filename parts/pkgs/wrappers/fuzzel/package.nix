{
  pkgs,
  wlib,

  colors, # Whoever tells you this is an unused binding is wrong
  # ff = 100%
  # e6 = 90%
  # d9 = 85%
  # c0 = 75%
  opacity ? {
    fg = "ff";
    bg = "c0";
  },
  fontSize ? 16,
}@args:
let
  colors = args.colors.default;
in
wlib.evalPackage {
  inherit pkgs;
  imports = [ wlib.wrapperModules.fuzzel ];

  settings = {
    main = {
      font = "monospace:size=${toString fontSize}";
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
}
