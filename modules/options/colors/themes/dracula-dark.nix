# TODO: use alucard theme as light theme for this one
pkgs: {
  bat.theme = "Dracula";
  helix.theme = "dracula";
  ghostty.theme = "Dracula";
  vicinae.theme = "dracula";
  zellij.theme = "dracula";
  scooter.theme = "dracula";
  theme-sh = "dracula";

  gtk.theme = {
    name = "Dracula";
    package = pkgs.dracula-theme;
  };

  cursor.theme = "Simp1e-Dracula";

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

  bright.black = "6272a4";
  bright.red = "ff6e6e";
  bright.green = "69ff94";
  bright.yellow = "ffffa5";
  bright.blue = "d6acff";
  bright.magenta = "ff92df";
  bright.cyan = "a4ffff";
  bright.white = "ffffff";

  orange = "ffb86c";
  bright.orange = "ffb86c"; # missing from spec

  comment = "6272a4";
  selection = "44475a";
  # subtle = "424450";
  unfocused = "44475a";
}
