# shellcheck shell=sh disable=SC3043

getcwd() {
	local cdup
	cdup=$(git rev-parse --show-cdup)
	if [ -z "$cdup" ]; then
		# either git failed or we're at git root
		return 1
	fi

	if [ "$cdup" != "../" ]; then
		cd "${cdup%../}" || return 1
	fi

	scope=$(basename "$(realpath "$(pwd)")")
}

getcwd || exit 1

if [ "$#" -eq 0 ]; then
	git commit -m "$scope: init"
	exit
fi

git commit -m "$scope: $*"
