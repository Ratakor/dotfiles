#!/bin/sh

trimall() {
	set -f
	# shellcheck disable=SC2086,SC2048
	set -- $*
	printf '%s\n' "$*"
	set +f
}

for _ in 1 2 3 4 5; do
	if text=$(curl -s "wttr.in?format=1&m"); then
		text=$(trimall "$text")
		if tooltip=$(curl -s "https://wttr.in?format=4&m"); then
			tooltip=$(trimall "$tooltip")
			printf '{"text":"%s","tooltip":"%s"}' "$text" "$tooltip"
			exit 0
		fi
	fi
	sleep 2
done
