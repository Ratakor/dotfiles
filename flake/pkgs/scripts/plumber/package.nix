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
    AUDIO="open music" # --shuffle
    PIC="open imv" # nsxiv -a
    DOC="open zathura"
    DIR="openterm yazi"
    DMENU=''${DMENU:-"dmenu -i"}
    TERMINAL=''${TERMINAL:-alacritty}
  '',
}:
writeShellApplication {
  name = "plumber";
  runtimeInputs = [
    # coreutils # mkdir
    # util-linux # setsid

    # tmpdl dependencies
    #curl
    #gnused

    # copy command (currently dynamic i.e. kinda using system available)
    #wl-clipboard
    #xclip
    #xsel

    # default programs
    #xdg-utils # xdg-open
    #editor...
    #mpv
    #imv
    #zathura
    #yazi
    #dmenu
    #alacritty

    # various dependencies
    #git
    #scripts.ytdl
    #scripts.randwp
  ];
  inheritPath = true;
  bashOptions = [
    "errexit"
    "pipefail"
  ];
  text = prelude + builtins.readFile ./plumber.sh;
  meta.mainProgram = "plumber";
}
