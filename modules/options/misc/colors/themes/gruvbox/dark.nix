{
  bat.theme = "gruvbox-dark";
  helix.theme = "gruvbox";
  ghostty.theme = "Gruvbox Dark";
  zellij.theme = "gruvbox-dark";
  noctalia.theme = "Gruvbox";

  qt.theme = pkgs: rec {
    name = "Gruvbox-Dark-Blue";
    package = pkgs.gruvbox-kvantum.override { variant = name; };
  };

  cursor.theme = "Simp1e-Gruvbox-Dark"; # "Simp1e-Gruvbox-Light"

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

  bright.black = "928374";
  bright.red = "fb4934";
  bright.green = "b8bb26";
  bright.yellow = "fabd2f";
  bright.blue = "83a598";
  bright.magenta = "d3869b";
  bright.cyan = "8ec07c";
  bright.white = "ebdbb2"; # foreground

  orange = "d65d0e";
  bright.orange = "fe8019";

  comment = "928374"; # gray
  selection = "504945"; # bg2
  unfocused = "3c3836"; # bg1

  # bg0_h = "1d2021";
  # bg0 = "282828"; # background
  # bg1 = "3c3836"; # unfocused
  # bg2 = "504945"; # selection
  # bg3 = "665c54";
  # bg4 = "7c6f64";
  # gray = "928374"; # bright_black / comment

  # bg0_s = "32302f";
  # fg4 = "a89984";
  # fg3 = "bdae93";
  # fg2 = "d5c4a1";
  # fg1 = "ebdbb2"; # foreground
  # fg0 = "fbf1c7";
}
