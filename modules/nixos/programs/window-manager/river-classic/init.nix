{ config, pkgs, ... }:
let
  inherit (config.hm.xdg.userDirs.extraConfig) NOTES;
  inherit (config.self.system) keyboard;
  prg = config.self.programs;
  dprg = prg.default;
  colors = config.self.colors.default;

  # TODO: also power off monitors
  lockCmd = dprg.locker.cmd;
in
# sh
''
  # shellcheck shell=sh disable=SC2016

  ### Shell variables

  export XDG_SESSION_TYPE='wayland'
  export XDG_CURRENT_DESKTOP='river'
  export MOZ_ENABLE_WAYLAND='1'
  export NIXOS_OZONE_WL='1' # enable ozone wayland for chromium and electron based apps

  ### WM config

  riverctl focus-follows-cursor normal
  riverctl attach-mode bottom
  riverctl hide-cursor when-typing enabled
  riverctl set-cursor-warp on-output-change
  riverctl set-repeat 50 300
  riverctl keyboard-layout -variant '${keyboard.variant}' -options '${keyboard.options}' '${keyboard.layout}'
  riverctl default-layout rivertile

  riverctl xcursor-theme '${colors.cursor.theme}' 24
  riverctl background-color '0x${colors.background}'
  riverctl border-color-focused '0x${colors.blue}'
  riverctl border-color-unfocused '0x${colors.unfocused}'
  riverctl border-color-urgent '0x${colors.red}'

  # TODO: output config like niri if possible

  ### WM bindings

  riverctl map normal Super F toggle-fullscreen
  riverctl map normal Super+Shift Q close
  riverctl map normal Super Space toggle-float

  for i in $(seq 1 9); do
  	tags=$((1 << (i - 1)))
  	riverctl map normal Super "$i" set-focused-tags $tags
  	riverctl map normal Super+Shift "$i" set-view-tags $tags
  	riverctl map normal Super+Control "$i" toggle-focused-tags $tags
  	riverctl map normal Super+Shift+Control "$i" toggle-view-tags $tags
  done
  tags1to9=$(((1 << 9) - 1))
  riverctl map normal Super 0 set-focused-tags $tags1to9
  riverctl map normal Super+Shift 0 set-view-tags $tags1to9

  riverctl map normal Super Tab focus-previous-tags
  riverctl map normal Super+Shift Tab send-to-previous-tags

  riverctl map normal Super J focus-view next
  riverctl map normal Super K focus-view previous
  riverctl map normal Super+Shift Return zoom
  riverctl map normal Super+Shift J swap next
  riverctl map normal Super+Shift K swap previous

  # next/previous or left/right
  riverctl map normal Super Period focus-output next
  riverctl map normal Super Comma focus-output previous
  riverctl map normal Super+Shift Period send-to-output next
  riverctl map normal Super+Shift Comma send-to-output previous

  riverctl map normal Super H send-layout-cmd rivertile 'main-ratio -0.05'
  riverctl map normal Super L send-layout-cmd rivertile 'main-ratio +0.05'
  riverctl map normal Super+Shift H send-layout-cmd rivertile 'main-count +1'
  riverctl map normal Super+Shift L send-layout-cmd rivertile 'main-count -1'

  riverctl map-pointer normal Super BTN_LEFT move-view
  riverctl map-pointer normal Super+Shift BTN_LEFT resize-view
  riverctl map-pointer normal Super BTN_RIGHT resize-view

  # Super+Alt+{H,J,K,L} to move views
  #riverctl map normal Super+Alt H move left 100
  #riverctl map normal Super+Alt J move down 100
  #riverctl map normal Super+Alt K move up 100
  #riverctl map normal Super+Alt L move right 100

  # Super+Alt+Control+{H,J,K,L} to snap views to screen edges
  #riverctl map normal Super+Alt+Control H snap left
  #riverctl map normal Super+Alt+Control J snap down
  #riverctl map normal Super+Alt+Control K snap up
  #riverctl map normal Super+Alt+Control L snap right

  # Super+Alt+Shift+{H,J,K,L} to resize views
  #riverctl map normal Super+Alt+Shift H resize horizontal -100
  #riverctl map normal Super+Alt+Shift J resize vertical 100
  #riverctl map normal Super+Alt+Shift K resize vertical -100
  #riverctl map normal Super+Alt+Shift L resize horizontal 100

  # Super+{Up,Right,Down,Left} to change layout orientation
  #riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
  #riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
  #riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
  #riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

  ### Custom bindings

  riverctl map normal Super Return spawn '${dprg.terminal.cmd}'
  riverctl map normal Super D spawn '${dprg.launcher.drun}'
  riverctl map normal Super+Shift D spawn '${dprg.launcher.run}'
  riverctl map normal None XF86ScreenSaver spawn '${lockCmd}'
  riverctl map normal Super+Shift X spawn '${lockCmd}'
  riverctl map normal None XF86Battery spawn 'battery'
  riverctl map normal Super+Shift W spawn 'wpaperctl next'
  riverctl map normal None Print spawn 'screenshot'
  riverctl map normal Shift Print spawn 'ocr'
  # riverctl map normal None F7 spawn '${dprg.terminal.cmd} -e dmenurecord'
  riverctl map normal Super B spawn '${dprg.browser.newWindow}'
  # riverctl map normal Super N spawn '${dprg.terminal.cmd} -e yazi ${NOTES}'
  # riverctl map normal Super N spawn '${dprg.terminal.cmdDir} ${NOTES} -e zellij attach --create notes'
  riverctl map normal Super N spawn '${dprg.terminal.cmd} -e zellij attach --create main'
  # riverctl map normal Super+Shift N spawn '${dprg.terminal.cmd} -e newsboat'
  riverctl map normal Super+Shift N spawn '${dprg.terminal.cmdDir} ${NOTES} -e zellij attach --create notes'

  riverctl map -repeat normal None XF86AudioRaiseVolume spawn 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+'
  riverctl map -repeat normal Super Equal spawn 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+'
  riverctl map -repeat normal None XF86AudioLowerVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'
  riverctl map -repeat normal Super Minus spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'
  riverctl map normal None XF86Launch1 spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
  riverctl map normal None F6 spawn 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'

  # riverctl map normal Super M spawn 'zpotify play playlist'    # 'music'
  # riverctl map normal Super+Shift M spawn 'zpotify play album' # 'musiccmd'
  riverctl map normal None XF86AudioPrev spawn 'playerctl previous'   # 'musiccmd prev || zpotify prev >/dev/null'
  riverctl map normal None XF86AudioNext spawn 'playerctl next'       # 'musiccmd next || zpotify next >/dev/null'
  riverctl map normal None XF86AudioPlay spawn 'playerctl play-pause' # 'musiccmd cycle || zpotify pause >/dev/null'
  riverctl map normal None XF86AudioStop spawn 'playerctl stop'       # 'musiccmd stop || zpotify pause >/dev/null'
  riverctl map normal Super+Shift Left spawn   'playerctl previous'   # 'musiccmd prev || zpotify prev >/dev/null'
  riverctl map normal Super+Shift Right spawn  'playerctl next'       # 'musiccmd next || zpotify next >/dev/null'
  riverctl map normal Super+Shift Down spawn   'playerctl play-pause' # 'musiccmd cycle || zpotify pause >/dev/null'
  riverctl map normal Super+Shift Up spawn     'playerctl stop'       # 'musiccmd stop || zpotify pause >/dev/null'

  riverctl map normal None XF86MonBrightnessUp spawn 'brightnessctl set +10%'
  riverctl map normal None XF86MonBrightnessDown spawn 'brightnessctl set 10%-'
  riverctl map normal Super Insert spawn 'brightnessctl set +10%'
  riverctl map normal Super Delete spawn 'brightnessctl set 10%-'

  # riverctl map normal Super S spawn 'dmenusearch web'
  # riverctl map normal Super A spawn 'dmenusearch aur'
  # riverctl map normal Super Y spawn 'dmenusearch youtube'
  # riverctl map normal Super W spawn 'dmenusearch man'
  riverctl map normal Super E spawn 'emojisearch' # 'dmenusearch emoji'

  riverctl map normal Super+Shift E spawn '${dprg.powerMenu.cmd}'
  riverctl map normal Super U spawn 'plumber --dmenu "$(wl-paste)"'
  riverctl map normal Super+Shift U spawn 'plumber "$(wl-paste)"'
  #riverctl map-pointer normal None BTN_MIDDLE spawn 'plumber'
  #riverctl map normal None button8 spawn 'plumber "$(wl-paste)"'
  #riverctl map normal None button9 close
  #riverctl map normal None button10 spawn 'musiccmd'

  # toggle bar
  riverctl map normal Super+Shift B spawn '${dprg.statusBar.toggle}'
  # TODO: toggle padding (gaps)
  #riverctl map normal Super+Shift G ...
  # cycle layout (toggle floating mode)
  # riverctl map normal Super+Shift Space spawn \
  # 	'killall rivertile || rivertile -view-padding 0 -outer-padding 0 -main-ratio 0.55'
  # TODO: toggle transparency
  #riverctl map normal Control P spawn 'killall picom || picom -b'

  ### Start programs

  riverctl spawn 'rivertile -view-padding 0 -outer-padding 0 -main-ratio 0.55'

  ### Extra config

  ${prg.windowManager.river-classic.extraConfig}

  ### Systemd activation

  ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all &&
    systemctl --user stop river-session.target &&
    systemctl --user start river-session.target
''
