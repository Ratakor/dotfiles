#!/bin/zsh

killall monerod
monerod --data-dir /storage/monero &

# Start graphical server on user's current tty if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec sx
