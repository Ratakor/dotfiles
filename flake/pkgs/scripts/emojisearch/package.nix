{
  lib,
  writeShellApplication,
  coreutils,
  gnused,
  libnotify,
  dmenu,
  xclip,

  dmenuCommand ? "${lib.getExe dmenu} -i -l 30",
  copyCommand ? "${lib.getExe xclip} -selection clipboard",
}:
writeShellApplication {
  name = "emojisearch";
  runtimeInputs = [
    coreutils
    gnused
    libnotify
  ];
  text = ''
    chosen=$(cut -d ';' -f1 "${./emoji}" | ${dmenuCommand} | sed "s/ .*//")
    [ -z "$chosen" ] && exit
    printf '%s' "$chosen" | ${copyCommand}
    notify-send "'$chosen' copied to clipboard."
  '';
  meta = {
    mainProgram = "emojisearch";
    description = "Search emojis with a dynamic menu";
  };
}
