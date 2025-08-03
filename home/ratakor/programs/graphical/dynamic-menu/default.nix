{
  colors,
  pkgs,
  ...
}: {
  programs.tofi = {
    enable = true;
    package = pkgs.tofi.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [./tofi-dmenu-20240910.diff];
    });
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
      background-color = colors.background; # "#000a";
      text-color = colors.foreground;
      selection-color = colors.cyan;
    };
  };
}
