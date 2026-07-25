# Set a random wallpaper.
# non-nix version of this script:
# https://raw.githubusercontent.com/Ratakor/dotfiles/ec0dc5e5240d2fef94afaa3cbe7f2cb9d5dcfce3/users/ratakor/programs/scripts/bin/randwp
# I don't know if there should be a timestamp when logging, anyway this should
# be rewritten into a daemon
{
  lib,
  writeShellApplication,
  findutils,
  coreutils,
  gnugrep,
  swaybg,
  wlr-randr,
  jq,
  xrandr,
  gawk,
  xwallpaper,
  hsetroot,

  isWayland ? false,
  supportMultipleMonitors ? true,
  wallpapers ? "\${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers",
  extensions ? [
    "jpeg"
    "jpg"
    "png"
  ]
  # xwallpaper (used on x11 with multiple monitors) doesn't support webp
  ++ (lib.optional (isWayland || !supportMultipleMonitors) "webp"),
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatMapStringsSep;
in
writeShellApplication {
  name = "randwp";
  runtimeInputs = [
    findutils
    coreutils
    gnugrep
  ];
  excludeShellChecks = [
    "SC2034" # PIDFILE appears unused. Verify use (or export if used externally).
    "SC2086" # Double quote to prevent globbing and word splitting.
  ];
  bashOptions = [ ]; # errexit sucks
  inheritPath = false;
  text = ''
    # Set a random wallpaper.
    # There must be no space in wallpaper filename.

    PIDFILE=''${XDG_RUNTIME_DIR:-/tmp}/randwp.pid
    LOGFILE=''${XDG_STATE_HOME:-$HOME/.local/state}/randwp.log
    WPDIR=''${1:-${wallpapers}}
    ALL=$(find "$WPDIR" -type f ! -path '*/.*' \( ${
      concatMapStringsSep " -o " (ext: "-iname '*.${ext}'") extensions
    } \))

    searchwp() {
      wp=$(printf '%s' "$ALL" | shuf -n 1)
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
        for output in $(${getExe xrandr} | ${getExe gawk} '$2=="connected" {print $1}'); do
          searchwp
          args="$args --output $output --zoom $wp"
        done
        # doing this speedup a lot, there must be no space in wallpaper filename
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
