# Automatically start River on tty1 if not already running.
if [ "$(tty)" = "/dev/tty1" ]  && ! pidof -s river >/dev/null 2>&1; then
	rm "$XDG_CONFIG_HOME/chromium/SingletonLock" >/dev/null 2>&1

	export XDG_SESSION_TYPE=wayland
	export XDG_CURRENT_DESKTOP=river

	timestamp=$(date +%F-%R)
	exec dbus-run-session river -log-level warning > "/tmp/river-$timestamp.log" 2>&1
fi
