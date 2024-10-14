# Add ~/.local/bin to $PATH
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$CARGO_HOME/bin"
PATH="$PATH:$GOPATH/bin"
export PATH
export MANPATH="$HOME/.local/share/man:/usr/local/share/man:/usr/share/man"
#export LD_LIBRARY_PATH="$HOME/.local/lib:/usr/local/lib:/usr/lib"

# Default programs
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="chromium"
export ROOTCMD="doas"
export MANPAGER="manpager"
export DMENU="dmenu -i"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.local/etc"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/var/cache"
export XDG_STATE_HOME="$HOME/.local/var/state"
export XDG_DESKTOP_DIR="$HOME/tmp"
export XDG_DOWNLOAD_DIR="$HOME/tmp"
export XDG_PUBLICSHARE_DIR="$HOME/tmp"
export XDG_TEMPLATES_DIR="$HOME/tmp"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/pic"
export XDG_VIDEOS_DIR="$HOME/vid"
export XDG_DOCUMENTS_DIR="$HOME/doc"

# ~/ Clean-up
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CARGO_TARGET_DIR="$XDG_CACHE_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export OPAMROOT="$XDG_DATA_HOME/opam"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export W3M_DIR="$XDG_STATE_HOME/w3m"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export DOOMWADDIR="$XDG_DATA_HOME/gzdoom"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# misc
# umask 0077
export GPG_TTY=$(tty)
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export MANWIDTH=80
LESS=-R
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
