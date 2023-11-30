# Update PATH
PATH="$HOME/.local/bin:$PATH"
PATH="$PATH:$CARGO_HOME/bin"
PATH="$PATH:$GOPATH/bin"
export PATH

# Default programs
export EDITOR="editor"
export TERMINAL="st"
export BROWSER="browser"
export ROOTCMD="doas"
export MANPAGER="manpager"

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
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
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

# Misc
# umask 0077
export GPG_TTY=$(tty)
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export MANWIDTH=80
export LESS=-R
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
# export CC="tcc -L/usr/local/lib"
# export CC="zig cc"
export CC=cc
CC="$CC -Wall"
export LD_LIBRARY_PATH=/usr/local/lib
export LS_COLORS="$(vivid generate gruvbox-dark):di=1;34"
