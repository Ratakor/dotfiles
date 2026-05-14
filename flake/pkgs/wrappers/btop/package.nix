{ lib, pkgs }:
lib.mkWrapperFor "btop" {
  inherit pkgs;
  settings = {
    color_theme = "TTY";
    theme_background = false;
    vim_keys = true;
    rounded_corners = false;
  };
}
