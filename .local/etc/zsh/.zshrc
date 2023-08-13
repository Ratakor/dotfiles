# fun stuff
quand -f 14
#shuf -n 1 "$XDG_DATA_HOME/navi" # database from https://github.com/HappyHippo77/NaviFrequencyList
tpercent
ls -a --color=auto --group-directories-first

# Source aliases
source "$ZDOTDIR/aliasrc"
[ -f "$ZDOTDIR/paliasrc" ] && source "$ZDOTDIR/paliasrc" # Private aliases

# Some basic settings
autoload -U colors && colors # Load colors
setopt AUTOCD # Automatically cd into typed directory.
stty stop undef # Disable ctrl-s to freeze terminal.
setopt RM_STAR_SILENT # disable double verification with rm -I *
bindkey -v # vi mode
export KEYTIMEOUT=1

# Prompt
timer=$(print -P %D{%s%3.})
function preexec() {
	timer=$(print -P %D{%s%3.})
	echo -ne "\e[5 q" # Use beam shape cursor for each new prompt.
}

function precmd() {
	local now=$(($(print -P %D{%s%3.}) - 2))
	[ -z "$timer" ] && timer=$now
	local d_ms=$(($now - $timer))
	local d_s=$((d_ms / 1000))
	local ms=$((d_ms % 1000))
	local s=$((d_s % 60))
	local m=$(((d_s / 60) % 60))
	local h=$((d_s / 3600))

	if   ((h > 0)); then elapsed=${h}h${m}m${s}s
	elif ((m > 0)); then elapsed=${m}m${s}.$(($ms / 100))s
	elif ((s > 9)); then elapsed=${s}.$(printf %02d $(($ms / 10)))s
	elif ((s > 0)); then elapsed=${s}.$(printf %03d $ms)s
	else elapsed=${ms}ms
	fi
	export PS1="%B%(?.0.%F{red}%?) %F{blue}${elapsed} %F{green}%~ %f%#%b "
	unset timer elapsed
}

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi modes.
function zle-keymap-select() {
	case $KEYMAP in
	vicmd)
		echo -ne '\e[1 q' ;; # block
	viins|main)
		echo -ne '\e[5 q' ;; # beam
	esac
}
function zle-line-init() {
	echo -ne '\e[5 q'
}
zle -N zle-keymap-select
zle -N zle-line-init

# git integration
autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f'
zstyle ':vcs_info:*' enable git
