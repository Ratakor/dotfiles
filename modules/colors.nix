# This probably shouldn't be in modules/
# TODO: neovim river
{
  gruvbox-dark = {
    bat.theme = "gruvbox-dark";

    gtk = {
      name = "Gruvbox-Dark";
      packageName = "gruvbox-gtk-theme";
    };

    foreground = "ebdbb2";
    background = "282828";

    black = "282828";
    red = "cc241d";
    green = "98971a";
    yellow = "d79921";
    blue = "458588";
    magenta = "b16286";
    cyan = "689d6a";
    white = "a89984";

    bright_black = "928374";
    bright_red = "fb4934";
    bright_green = "b8bb26";
    bright_yellow = "fabd2f";
    bright_blue = "83a598";
    bright_magenta = "d3869b";
    bright_cyan = "8ec07c";
    bright_white = "ebdbb2";

    orange = "d65d0e";
    bright_orange = "fe8019";
  };

  gruvbox-light = {
    bat.theme = "gruvbox-light";

    gtk = {
      name = "Gruvbox-Light";
      packageName = "gruvbox-gtk-theme";
    };

    foreground = "3c3836";
    background = "fbf1c7";

    black = "fbf1c7";
    red = "cc241d";
    green = "98971a";
    yellow = "d79921";
    blue = "458588";
    magenta = "b16286";
    cyan = "689d6a";
    white = "7c6f64";

    bright_black = "928374";
    bright_red = "9d0006";
    bright_green = "79740e";
    bright_yellow = "b57614";
    bright_blue = "076678";
    bright_magenta = "8f3f71";
    bright_cyan = "427b58";
    bright_white = "3c3836";

    orange = "d65d0e";
    bright_orange = "af3a03";
  };

  dracula = {
    bat.theme = "Dracula";

    gtk = {
      name = "Dracula";
      packageName = "dracula-theme";
    };

    foreground = "f8f8f2";
    background = "282a36";

    black = "21222c";
    red = "ff5555";
    green = "50fa7b";
    yellow = "f1fa8c";
    blue = "bd93f9";
    magenta = "ff79c6";
    cyan = "8be9fd";
    white = "f8f8f2";

    bright_black = "6272a4";
    bright_red = "ff6e6e";
    bright_green = "69ff94";
    bright_yellow = "ffffa5";
    bright_blue = "d6acff";
    bright_magenta = "ff92df";
    bright_cyan = "a4ffff";
    bright_white = "ffffff";

    orange = "ffb86c";
    bright_orange = "ffb86c"; # missing from spec
  };
}
