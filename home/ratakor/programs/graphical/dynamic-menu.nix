{
  colors,
  pkgs,
  ...
}: {
  programs.tofi = {
    enable = true;
    package = pkgs.tofi-dmenu;
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
      background-color = colors.background + "e6"; # "#000a";
      text-color = colors.foreground;
      selection-color = colors.cyan;
    };
  };
}
