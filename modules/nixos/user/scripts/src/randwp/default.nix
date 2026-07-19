# Set a random wallpaper.
# non-nix version of this script:
# https://raw.githubusercontent.com/Ratakor/dotfiles/ec0dc5e5240d2fef94afaa3cbe7f2cb9d5dcfce3/users/ratakor/programs/scripts/bin/randwp
# I don't know if there should be a timestamp when logging, anyway this should
# be rewritten into a daemon
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;

  supportMultipleMonitors = builtins.length config.self.device.monitors > 1;
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

    PIDFILE=''${XDG_RUNTIME_DIR:-/tmp}/randwp.pid
    LOGFILE=''${XDG_STATE_HOME:-$HOME/.local/state}/randwp.log
    WPDIR=''${1:-${config.hm.xdg.userDirs.extraConfig.WALLPAPERS}}
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
    # if displayServer.wayland then
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
        OLDPID=$(cat "$PIDFILE" 2>/dev/null)
        # shellcheck disable=SC2086
        ${swaybg} $args 2>/dev/null &
        echo $! > "$PIDFILE"
        (sleep 3; kill "$OLDPID" 2>/dev/null || exit 0) &
      ''
    else
      ''
        # Single screen on wayland with swaybg
        searchwp
        OLDPID=$(cat "$PIDFILE" 2>/dev/null)
        ${swaybg} -m fill -i "$wp" 2>/dev/null &
        echo $! > "$PIDFILE"
        (sleep 3; kill "$OLDPID" 2>/dev/null || exit 0) &
      ''
    # else if displayServer.x11 then
    #   if supportMultipleMonitors then
    #     let
    #       xwallpaper = getExe pkgs.xwallpaper;
    #       xrandr = getExe pkgs.xorg.xrandr;
    #       awk = getExe pkgs.gawk;
    #     in
    #     ''
    #       # Multiple screens on X11 with xwallpaper
    #       IGNORE="$IGNORE|.webp" # xwallpaper doesn't support webp
    #       for output in $(${xrandr} | ${awk} '$2=="connected" {print $1}'); do
    #       	searchwp
    #       	args="$args --output $output --zoom $wp"
    #       done
    #       # doing this speedup a lot, there must be no space in wallpaper filename
    #       # shellcheck disable=SC2086
    #       ${xwallpaper} $args
    #     ''
    #   else
    #     let
    #       hsetroot = getExe pkgs.hsetroot;
    #     in
    #     ''
    #       # Single screen on X11 with hsetroot
    #       searchwp
    #       ${hsetroot} -cover "$wp" 1>/dev/null
    #     ''
    # else
    #   lib.unreachable
  );
}
