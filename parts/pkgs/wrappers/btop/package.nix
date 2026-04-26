{ pkgs, wlib }:
wlib.evalPackage {
  inherit pkgs;
  imports = [ wlib.wrapperModules.btop ];

  settings = {
    color_theme = "TTY";
    theme_background = false;
    vim_keys = true;
    rounded_corners = false;
  };
}
