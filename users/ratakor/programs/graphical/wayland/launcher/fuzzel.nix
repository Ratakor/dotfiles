# opacity:
# ff = 100%
# e6 = 90%
# d9 = 85%
{colors, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace";
        horizontal-pad = 5;
        vertical-pad = 5;
      };

      colors = rec {
        background = colors.background + "d9";
        text = colors.foreground + "ff";
        prompt = text;
        placeholder = colors.comment + "ff";
        input = text;
        match = colors.orange + "ff"; # or cyan
        selection = colors.selection + "d9";
        selection-text = text;
        selection-match = match;
        counter = placeholder;
        border = colors.blue + "ff";
      };

      border = {
        width = 2;
        radius = 0;
      };
    };
  };
}
