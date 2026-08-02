#!/bin/sh
# shellcheck disable=SC2046

if [ "$NOCTALIA_THEME_MODE" = "dark" ]; then
  kill -USR1 $(pidof foot)
elif [ "$NOCTALIA_THEME_MODE" = "light" ]; then
  kill -USR2 $(pidof foot)
fi
