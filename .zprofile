#!/bin/zsh

# Add ~/.local/bin to $PATH
export PATH="$HOME/.local/bin/dwmblocks:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="ungoogled-chromium"
export ROOTCMD="doas"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
#export CARGO_HOME="$XDG_DATA_HOME/cargo"
#export GOPATH="$XDG_DATA_HOME/go"

# Start graphical server on user's current tty if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec sx
