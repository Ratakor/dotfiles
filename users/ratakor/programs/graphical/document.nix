{
  programs.zathura = {
    enable = true;
    options = {
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;
      selection-clipboard = "clipboard";
      window-title-basename = true;
      statusbar-basename = true;
    };
    mappings = {
      i = "recolor";
      p = "print";
      w = "adjust_window width";
      W = "adjust_window best-fit";
    };
  };
}
