# Simple music selector that uses and interacts with mpv.
# non-nix version of this script:
# https://raw.githubusercontent.com/Ratakor/dotfiles/ec0dc5e5240d2fef94afaa3cbe7f2cb9d5dcfce3/users/ratakor/programs/scripts/bin/music
{
  config,
  lib,
  pkgs,
  self,
}: let
  inherit (builtins) readFile;
  inherit (lib.meta) getExe;

  XDG_MUSIC_DIR = config.xdg.userDirs.music;
  # TODO: allow to configure that
  DMENU = "${getExe self.pkgs.tofi-dmenu} --padding-left 25%";

  local-script = pkgs.writeTextFile {
    name = "local.lua";
    text = readFile ./local.lua;
  };

  online-script = pkgs.writeTextFile {
    name = "online.lua";
    text = readFile ./online.lua;
  };

  music = pkgs.writeShellApplication {
    name = "music";
    runtimeInputs = with pkgs; [coreutils gnugrep socat mpv];
    bashOptions = [];
    inheritPath = false;
    text = ''
      MUSICDIR=${XDG_MUSIC_DIR}
      SOCKET=''${XDG_RUNTIME_DIR:-/tmp}/music.sock

      if [ "$1" = "--shuffle" ]; then
      	shuffle=yes
      	shift
      fi

      # shellcheck disable=SC2012
      music="''${1:-$MUSICDIR/$(ls "$MUSICDIR" | cut -c 1-50 | ${DMENU} -p "Play")}"
      script=${local-script}

      if [ "$music" = "$MUSICDIR/urls" ]; then
      	# shellcheck disable=SC2012
      	music="$(cat "$MUSICDIR/urls/$(ls "$MUSICDIR/urls" | ${DMENU} -p "Play")")"
      	script=${online-script}
      fi

      [ "$music" = "$MUSICDIR/" ] || [ -z "$music" ] && exit 1

      if [ -z "$shuffle" ] && [ -d "$music" ] || printf '%s' "$music" | grep -q playlist; then
      	shuffle="$(printf 'yes\nno' | ${DMENU} -p 'Shuffle?')"
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
