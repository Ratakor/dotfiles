{
  bat.theme = "gruvbox-light";
  helix.theme = "gruvbox_light";
  ghostty.theme = "Gruvbox Light";
  zellij.theme = "gruvbox-light";
  noctalia.theme = "Gruvbox";

  qt.theme = pkgs: rec {
    name = "Gruvbox_Light_Green";
    package = pkgs.gruvbox-kvantum.override { variant = name; };
  };

  cursor.theme = "Simp1e-Gruvbox-Light"; # "Simp1e-Gruvbox-Dark"

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

  bright.black = "928374";
  bright.red = "9d0006";
  bright.green = "79740e";
  bright.yellow = "b57614";
  bright.blue = "076678";
  bright.magenta = "8f3f71";
  bright.cyan = "427b58";
  bright.white = "3c3836";

  orange = "d65d0e";
  bright.orange = "af3a03";

  comment = "928374"; # gray
  selection = "d5c4a1"; # bg2
  unfocused = "ebdbb2"; # bg1
}
