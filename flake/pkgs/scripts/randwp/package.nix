# Set a random wallpaper.
# non-nix version of this script:
# https://raw.githubusercontent.com/Ratakor/dotfiles/ec0dc5e5240d2fef94afaa3cbe7f2cb9d5dcfce3/users/ratakor/programs/scripts/bin/randwp
# I don't know if there should be a timestamp when logging, anyway this should
# be rewritten into a daemon
{
  lib,
  sources,
  writeShellApplication,
  findutils,
  coreutils,
  gnugrep,
  swaybg,
  wlr-randr,
  jq,
  xrandr,
  awk,
  xwallpaper,
  hsetroot,

  isWayland ? false,
  supportMultipleMonitors ? true,
  wallpapers ? sources.wallpapers,
}:
let
  inherit (lib.meta) getExe;
in
writeShellApplication {
  name = "randwp";
  runtimeInputs = [
    findutils
    coreutils
    gnugrep
  ];
  bashOptions = [ ]; # errexit sucks
  inheritPath = false;
  text = ''
    # Set a random wallpaper.
    # There must be no space in wallpaper filename.
    # To ignore a folder or a file put it in IGNORE after the - like below
    # IGNORE=''${IGNORE-file1|folder|file2|.ext}
    # IGNORE can be an env variable (useful for yazi)

    PIDFILE=''${XDG_RUNTIME_DIR:-/tmp}/randwp.pid
    LOGFILE=''${XDG_STATE_HOME:-$HOME/.local/state}/randwp.log
    WPDIR=''${1:-${wallpapers}}
    IGNORE=''${IGNORE-nsfw}
    ALL=$(find -L "$WPDIR" -type f ! -path '*/.*' ! -name 'README.md')

    searchwp() {
      wp=$(printf '%s' "$ALL" | shuf -n 1)
      if [ -n "$IGNORE" ]; then
        while printf '%s' "$wp" | grep -q -E "$IGNORE" ; do
          wp=$(printf '%s' "$ALL" | shuf -n 1)
        done
      fi
      printf '%s\n' "$wp" >> "$LOGFILE"
    }

  ''
  + (
    if isWayland then
      if supportMultipleMonitors then
        ''
          # Multiple screens on wayland with swaybg
          for output in $(${getExe wlr-randr} --json | ${getExe jq} -r '.[] | select(.enabled) | .name'); do
            searchwp
            args="$args -o $output -m fill -i $wp"
          done
          OLDPID=$(cat "$PIDFILE" 2>/dev/null)
          # shellcheck disable=SC2086
          ${getExe swaybg} $args 2>/dev/null &
          echo $! > "$PIDFILE"
          (sleep 3; kill "$OLDPID" 2>/dev/null || exit 0) &
        ''
      else
        ''
          # Single screen on wayland with swaybg
          searchwp
          OLDPID=$(cat "$PIDFILE" 2>/dev/null)
          ${getExe swaybg} -m fill -i "$wp" 2>/dev/null &
          echo $! > "$PIDFILE"
          (sleep 3; kill "$OLDPID" 2>/dev/null || exit 0) &
        ''
    else if supportMultipleMonitors then
      ''
        # Multiple screens on X11 with xwallpaper
        IGNORE="$IGNORE|.webp" # xwallpaper doesn't support webp
        for output in $(${getExe xrandr} | ${getExe awk} '$2=="connected" {print $1}'); do
          searchwp
          args="$args --output $output --zoom $wp"
        done
        # doing this speedup a lot, there must be no space in wallpaper filename
        # shellcheck disable=SC2086
        ${getExe xwallpaper} $args
      ''
    else
      ''
        # Single screen on X11 with hsetroot
        searchwp
        ${getExe hsetroot} -cover "$wp" 1>/dev/null
      ''
  );
  meta.mainProgram = "randwp";
}
