#!/bin/sh
case $1 in
period-changed)
	exec notify-send "Gammastep" "Period changed to $3" ;;
*)
	exec notify-send "Gammastep" "Unknown event: $*" ;;
esac
