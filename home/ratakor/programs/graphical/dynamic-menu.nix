# TODO: replace tofi with fuzzel
# opacity:
# ff = 100%
# e6 = 90%
# d9 = 85%
{
  colors,
  vega,
  ...
}: {
  programs = {
    tofi = {
      enable = true;
      package = vega.pkgs.tofi-dmenu;
      settings = {
        width = "100%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        padding-left = "33%";
        padding-top = "33%";
        result-spacing = 5;
        num-results = 10;
        font = "monospace";
        require-match = false;
        background-color = colors.background + "d9"; # "#000a";
        text-color = colors.foreground;
        selection-color = colors.cyan;
      };
    };

    fuzzel = {
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
  };
}
