# Search emojis with a dynamic menu
{ config, pkgs, ... }:
let
  emojiDisplayed = 30;
  DMENU = config.self.programs.default.launcher.dmenu;
in
pkgs.writeShellApplication {
  name = "emojisearch";
  runtimeInputs = with pkgs; [
    coreutils
    gnused
    libnotify
    wl-clipboard
  ];
  bashOptions = [
    "errexit"
    "pipefail"
  ];
  inheritPath = true; # for DMENU
  text = ''
    chosen=$(cut -d ';' -f1 "${./emoji}" | ${DMENU} -i -l ${toString emojiDisplayed} | sed "s/ .*//")
    [ -z "$chosen" ] && exit 1
    printf '%s' "$chosen" | wl-copy
    notify-send "'$chosen' copied to clipboard."
  '';
}
