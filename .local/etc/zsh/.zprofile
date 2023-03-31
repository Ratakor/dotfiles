#!/bin/zsh

doas modprobe dell-smm-hwmon ignore_dmi=1

GPG_TTY=$(tty)
export GPG_TTY

# Autostart xorg on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec sx
