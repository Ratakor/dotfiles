#!/bin/sh
SOCKET=${XDG_RUNTIME_DIR:-/tmp}/music.sock

[ -z "$(pgrep music)" ] && exit 1

strip() {
	tmp="${1##{\"data\":\"}"
	printf '%s\n' "${tmp%%\",\"request_id\":0,\"error\":\"success\"\}}"
}

pause=$(strip "$(printf '{ "command": ["get_property_string", "pause"] }\n' |
	socat - "$SOCKET" 2>/dev/null)")
title=$(strip "$(printf '{ "command": ["get_property", "media-title"] }\n' |
	socat - "$SOCKET" 2>/dev/null)")

if [ "$pause" = "yes" ]; then
	printf ' %s' "$title"
elif [ "$pause" = "no" ]; then
	printf ' %s' "$title"
fi
