if [ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1; then
    doas modprobe dell-smm-hwmon ignore_dmi=1
    rm "$XDG_CONFIG_HOME/chromium/SingletonLock" >/dev/null 2>&1
    exec sx
fi
