#!/bin/zsh

# Add ~/.local/bin to $PATH
export PATH="$HOME/.local/bin:$PATH"

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="chromium"
export ROOTCMD="doas"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# XDG
export XDG_CONFIG_HOME="$HOME/.local/etc"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/var/cache"
export XDG_STATE_HOME="$HOME/.local/var/state"
export XDG_DESKTOP_DIR="$HOME/tmp"
export XDG_DOCUMENTS_DIR="$HOME/tmp"
export XDG_DOWNLOAD_DIR="$HOME/tmp"
export XDG_PUBLICSHARE_DIR="$HOME/tmp"
export XDG_TEMPLATES_DIR="$HOME/tmp"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/pic"
export XDG_VIDEOS_DIR="$HOME/vid"

# ~/ Clean-up:
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export OPAMROOT="$XDG_DATA_HOME/opam"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
