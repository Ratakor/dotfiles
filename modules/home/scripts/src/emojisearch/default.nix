# Search emojis with a dynamic menu
{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib.trivial) unreachable;

  cfg = config.self;

  copyCommand =
    if cfg.displayServer == "x11" then
      "xclip -selection clipboard"
    else if cfg.displayServer == "wayland" then
      "wl-copy"
    else
      unreachable;
  emojiDisplayed = 30;
  DMENU = cfg.menu.dynamic;
in
pkgs.writeShellApplication {
  name = "emojisearch";
  runtimeInputs = with pkgs; [
    coreutils
    gnused
    libnotify
  ];
  bashOptions = [
    "errexit"
    "pipefail"
  ];
  inheritPath = true; # for DMENU
  text = ''
    chosen=$(cut -d ';' -f1 "${./emoji}" | ${DMENU} -i -l ${toString emojiDisplayed} | sed "s/ .*//")
    [ -z "$chosen" ] && exit 1
    printf '%s' "$chosen" | ${copyCommand}
    notify-send "'$chosen' copied to clipboard."
  '';
}
