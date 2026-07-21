# shellcheck shell=sh
# set -e

usage() {
	printf 'Usage: %s [-d] command\n' "${0##*/}" >&2
	exit 1
}

dir=false
cmd=

for arg; do
	case "$arg" in
	-d)
		dir=true
		;;
	-*)
		printf 'Unknown option: %s\n' "$arg" >&2
		usage
		;;
	*)
		if [ -n "$cmd" ]; then
			usage
		fi
		cmd=$arg
		;;
	esac
done

if [ -z "$cmd" ]; then
	usage
fi

# idk it feels too verbose without redirecting stderr
path=$(realpath "$(which "$cmd" 2>/dev/null)" 2>/dev/null)

if "$dir"; then
	dirname "$path"
else
	printf '%s\n' "$path"
fi
