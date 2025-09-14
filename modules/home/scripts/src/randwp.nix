# Set a random wallpaper.
# non-nix version of this script:
# https://raw.githubusercontent.com/Ratakor/dotfiles/ec0dc5e5240d2fef94afaa3cbe7f2cb9d5dcfce3/users/ratakor/programs/scripts/bin/randwp
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (self.pins) wallpapers;
  inherit (self.lib.trivial) unreachable;

  inherit (config.self) displayServer;
  supportMultipleMonitors = true;
in
pkgs.writeShellApplication {
  name = "randwp";
  runtimeInputs = with pkgs; [
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

    TMPDIR=''${XDG_RUNTIME_DIR:-/tmp}
    WPDIR=''${1:-${wallpapers}}
    IGNORE=''${IGNORE-nsfw}
    ALL=$(find -L "$WPDIR" -type f ! -path '*/.git*' ! -name 'README.md')

    searchwp() {
    	wp=$(printf '%s' "$ALL" | shuf -n 1)
    	if [ -n "$IGNORE" ]; then
    		while printf '%s' "$wp" | grep -q -E "$IGNORE" ; do
    			wp=$(printf '%s' "$ALL" | shuf -n 1)
    		done
    	fi
    }

  ''
  + (
    if displayServer == "wayland" then
      let
        swaybg = getExe pkgs.swaybg;
      in
      if supportMultipleMonitors then
        let
          wlr-randr = getExe pkgs.wlr-randr;
          jq = getExe pkgs.jq;
        in
        ''
          # Multiple screens on wayland with swaybg
          for output in $(${wlr-randr} --json | ${jq} -r '.[] | select(.enabled) | .name'); do
          	searchwp
          	args="$args -o $output -m fill -i $wp"
          done
          OLD_PID=$(cat "$TMPDIR/swaybg.pid" 2>/dev/null)
          # shellcheck disable=SC2086
          ${swaybg} $args 2>/dev/null &
          echo $! > "$TMPDIR/swaybg.pid"
          (sleep 3 && kill "$OLD_PID" 2>/dev/null || exit 0) &
        ''
      else
        ''
          # Single screen on wayland with swaybg
          searchwp
          OLD_PID=$(cat "$TMPDIR/swaybg.pid" 2>/dev/null)
          ${swaybg} -m fill -i "$wp" 2>/dev/null &
          echo $! > "$TMPDIR/swaybg.pid"
          (sleep 3 && kill "$OLD_PID" 2>/dev/null || exit 0) &
        ''
    else if displayServer == "x11" then
      if supportMultipleMonitors then
        let
          xwallpaper = getExe pkgs.xwallpaper;
          xrandr = getExe pkgs.xorg.xrandr;
          awk = getExe pkgs.gawk;
        in
        ''
          # Multiple screens on X11 with xwallpaper
          IGNORE="$IGNORE|.webp" # xwallpaper doesn't support webp
          for output in $(${xrandr} | ${awk} '$2=="connected" {print $1}'); do
          	searchwp
          	args="$args --output $output --zoom $wp"
          done
          # doing this speedup a lot, there must be no space in wallpaper filename
          # shellcheck disable=SC2086
          ${xwallpaper} $args
        ''
      else
        let
          hsetroot = getExe pkgs.hsetroot;
        in
        ''
          # Single screen on X11 with hsetroot
          searchwp
          ${hsetroot} -cover "$wp" 1>/dev/null
        ''
    else
      unreachable
  );
}
