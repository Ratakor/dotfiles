{
  writeShellApplication,

  # default programs:
  # use open for gui and openterm for terminal applications
  # currently assuming that WEB, VIDEO and AUDIO handle URLs
  prelude ? /* sh */ ''
    WEB="open ''${BROWSER:-"xdg-open"}"
    if [ -n "$VISUAL" ]; then
      TEXT="open $VISUAL"
    else
      TEXT="openterm $EDITOR"
    fi
    VIDEO="open mpv --loop" # --ytdl-format=bv+ba
    AUDIO="open mpv --video=no --loop-playlist --ytdl-format=ba" # --shuffle
    PIC="open imv" # nsxiv -a
    DOC="open zathura"
    DIR="openterm yazi"
    TERMINAL=''${TERMINAL:-alacritty}
  '',
}:
writeShellApplication {
  name = "plumber";
  # TODO: handle this
  runtimeInputs = [
    #coreutils # mkdir
    #util-linux # setsid

    # tmpdl dependencies
    #curl
    #gnused

    # various dependencies
    #git

    # default programs
    #xdg-utils # xdg-open
    #editor...
    #mpv
    #imv
    #zathura
    #yazi
    #alacritty
  ];
  inheritPath = true;
  bashOptions = [
    "errexit"
    "pipefail"
  ];
  excludeShellChecks = [
    "SC2086" # Double quote to prevent globbing and word splitting.
  ];
  text = prelude + builtins.readFile ./plumber.sh;
  meta.mainProgram = "plumber";
}
