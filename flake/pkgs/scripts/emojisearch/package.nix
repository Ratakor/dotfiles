{
  lib,
  writeShellApplication,
  coreutils,
  gnused,
  libnotify,
  dmenu,
  xclip,

  dmenuCommand ? lib.getExe dmenu,
  copyCommand ? "${lib.getExe xclip} -selection clipboard",
  emojiDisplayed ? 30,
}:
writeShellApplication {
  name = "emojisearch";
  runtimeInputs = [
    # coreutils
    # gnused
    # libnotify
  ];
  bashOptions = [
    "errexit"
    "pipefail"
  ];
  inheritPath = true; # for DMENU
  text = ''
    chosen=$(cut -d ';' -f1 "${./emoji}" | ${dmenuCommand} -i -l ${toString emojiDisplayed} | sed "s/ .*//")
    [ -z "$chosen" ] && exit 1
    printf '%s' "$chosen" | ${copyCommand}
    notify-send "'$chosen' copied to clipboard."
  '';
  meta = {
    mainProgram = "emojisearch";
    description = "Search emojis with a dynamic menu";
  };
}
