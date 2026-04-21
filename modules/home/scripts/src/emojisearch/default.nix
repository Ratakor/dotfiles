# Search emojis with a dynamic menu
{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib.trivial) unreachable;

  sys = config.self.system;
  dprg = config.self.programs.default;

  copyCommand =
    if sys.displayServer.x11 then
      "xclip -selection clipboard"
    else if sys.displayServer.wayland then
      "wl-copy"
    else
      unreachable;
  emojiDisplayed = 30;
  DMENU = dprg.launcher.dmenu;
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
