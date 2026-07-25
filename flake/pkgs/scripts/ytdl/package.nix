{
  writeShellApplication,
  coreutils,
  libnotify,
  yt-dlp,
}:
writeShellApplication {
  name = "ytdl";
  runtimeInputs = [
    coreutils
    libnotify
    yt-dlp
  ];
  excludeShellChecks = [
    "SC2015" # Note that A && B || C is not if-then-else. C may run when A is true.
  ];
  text = ''
    # first argument is type
    # v for video
    # m for music
    # p for playlist
    # if omitted the default is video
    # second and third argument are output directory and url
    # they are interchangeable

    type=$1
    case $type in
    v | m | p) shift ;;
    *) type=v ;;
    esac

    if [ -d "$1" ]; then
      musicdir=$1
      videodir=$1
      url=$2
    else
      # i know about ''${a:-b} stfu
      if [ -z "$2" ]; then
        musicdir=''${XDG_MUSIC_DIR:-$HOME/Music}
        videodir=''${XDG_VIDEOS_DIR:-$HOME/Videos}
        if [ "$type" = p ]; then
          musicdir=$musicdir/playlist-$RANDOM
        fi
      else
        musicdir=$2
        videodir=$2
      fi
      url=$1
    fi

    case $type in
    v)
      mkdir -p "$videodir"
      notify-send "Video download started"
      yt-dlp -f 'bv+ba' -o '%(title)s [%(id)s].%(ext)s' \
        --embed-metadata -P "$videodir" "$url" &&
        notify-send "Video downloaded" ||
        (
          notify-send "Error: Download failed"
          exit 1
        )
      ;;
    m)
      mkdir -p "$musicdir"
      notify-send "Music download started"
      yt-dlp -f 'ba' -o '%(title)s [%(id)s].%(ext)s' \
        -x --embed-thumbnail --audio-format mp3 \
        --embed-metadata -P "$musicdir" "$url" &&
        notify-send "Music downloaded" ||
        (
          notify-send "Error: Download failed"
          exit 1
        )
      ;;
    p)
      mkdir -p "$musicdir"
      notify-send "Playlist download started"
      yt-dlp -f 'ba' -o '%(playlist_index)s - %(title)s [%(id)s].%(ext)s' \
        -x --embed-thumbnail --audio-format mp3 \
        --embed-metadata -P "$musicdir" "$url" &&
        notify-send "Playlist downloaded" ||
        (
          notify-send "Error: Download failed"
          exit 1
        )
      ;;
    *)
      exit 1
      ;;
    esac
  '';
  meta = {
    mainProgram = "ytdl";
    description = "Wrapper for yt-dlp with notification support";
  };
}
