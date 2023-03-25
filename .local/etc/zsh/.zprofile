#!/bin/zsh

doas modprobe dell-smm-hwmon ignore_dmi=1

killall monerod
monerod --data-dir /storage/monero > /tmp/monerod.log 2>&1 &

# Autostart xorg on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec sx
