# Automatically start River on tty1 if not already running.
if [ "$(tty)" = "/dev/tty1" ]  && ! pidof -s river >/dev/null 2>&1; then
	#rm "$XDG_CONFIG_HOME/chromium/SingletonLock" >/dev/null 2>&1

	export XDG_SESSION_TYPE=wayland
	export XDG_CURRENT_DESKTOP=river

	timestamp=$(date +%F-%R)
	RIVER_LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/river"
	mkdir -p "$RIVER_LOG_DIR"
	exec dbus-run-session river -log-level warning > "${RIVER_LOG_DIR}/river-${timestamp}.log" 2>&1
fi
