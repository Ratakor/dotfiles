# Simple music selector that uses and interacts with mpv.
# non-nix version of this script:
# https://raw.githubusercontent.com/Ratakor/dotfiles/ec0dc5e5240d2fef94afaa3cbe7f2cb9d5dcfce3/users/ratakor/programs/scripts/bin/music
{
  config,
  pkgs,
}:
let
  XDG_MUSIC_DIR = config.hm.xdg.userDirs.music;
  DMENU =
    if config.self.menu.dynamic == "tofi" then "tofi --padding-left 25%" else config.self.menu.dynamic;

  music = pkgs.writeShellApplication {
    name = "music";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      socat
      mpv
    ];
    bashOptions = [ ];
    inheritPath = true; # needed for DMENU
    text = ''
      MUSICDIR=${XDG_MUSIC_DIR}
      SOCKET=''${XDG_RUNTIME_DIR:-/tmp}/music.sock

      if [ "$1" = "--shuffle" ]; then
      	shuffle=yes
      	shift
      fi

      # shellcheck disable=SC2012
      music="''${1:-$MUSICDIR/$(ls "$MUSICDIR" | cut -c 1-50 | ${DMENU})}"
      script=${./local.lua}

      if [ "$music" = "$MUSICDIR/urls" ]; then
      	# shellcheck disable=SC2012
      	music="$(cat "$MUSICDIR/urls/$(ls "$MUSICDIR/urls" | ${DMENU})")"
      	script=${./online.lua}
      fi

      [ "$music" = "$MUSICDIR/" ] || [ -z "$music" ] && exit 1

      if [ -z "$shuffle" ] && [ -d "$music" ] || printf '%s' "$music" | grep -q playlist; then
      	shuffle="$(printf 'yes\nno' | ${DMENU} -p 'Shuffle? ')"
      	[ -z "$shuffle" ] && exit 1
      fi

      printf 'stop\n' | socat - "$SOCKET" 2> /dev/null
      # TODO: add --volume=60 on AuroraR7
      mpv --vid=no --input-ipc-server="$SOCKET" --loop-playlist\
      	--ytdl-format=ba --script="$script" --shuffle="$shuffle" "$music"
    '';
  };
in
music
