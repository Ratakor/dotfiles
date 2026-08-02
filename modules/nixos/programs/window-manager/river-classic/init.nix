{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) isList split length;
  inherit (lib.lists) ifold1;
  inherit (lib.strings) concatMapAttrsStringSep;

  convertModifier =
    mod:
    if mod == "Mod" then
      "Super"
    else if mod == "Ctrl" then
      "Control"
    else
      mod;

  inherit (config.hm.xdg.userDirs.extraConfig) SCREENSHOTS;
  inherit (config.self.system) keyboard cursor;
  prg = config.self.programs;
  colors = config.self.colors.default;

  # TODO: also power off monitors
  lockCmd = prg.default.locker.cmd;
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

  riverctl xcursor-theme '${cursor.theme}' ${toString cursor.size}
  riverctl background-color '0x${colors.background}'
  riverctl border-color-focused '0x${colors.blue}'
  riverctl border-color-unfocused '0x${colors.unfocused}'
  riverctl border-color-urgent '0x${colors.red}'

  # TODO: output (as in monitor) config like niri if possible

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

  # TODO: use swappy?
  riverctl map normal None Print spawn 'grim -g "$(slurp)" - | tee "${SCREENSHOTS}/$(date "+%Y-%m-%d_%H:%M:%S").png" | wl-copy'
  riverctl map normal Control Print spawn 'grim - | tee "${SCREENSHOTS}/$(date "+%Y-%m-%d_%H:%M:%S").png" | wl-copy'
  # TODO: Alt Print screenshot-window

  # TODO: move to prg.windowManager.binds
  riverctl map normal None XF86ScreenSaver spawn '${lockCmd}'
  riverctl map normal Super+Shift X spawn '${lockCmd}'

  ${concatMapAttrsStringSep "\n" (
    name: value:
    "riverctl map normal ${
      let
        components = split "\\+" name;
        len = length components;
      in
      if len == 1 then
        "None ${name}"
      else
        ifold1 (
          acc: i: x:
          if isList x then
            acc
          else if i == 1 then
            convertModifier x
          else if i == len then
            "${acc} ${x}"
          else
            "${acc}+${convertModifier x}"
        ) "" components
    } spawn '${value.spawn}'"
  ) prg.windowManager.binds}

  ### Start programs

  riverctl spawn 'rivertile -view-padding 0 -outer-padding 0 -main-ratio 0.55'

  ### Extra config

  ${prg.windowManager.river-classic.extraConfig}

  ### Systemd activation

  ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all &&
    systemctl --user stop river-session.target &&
    systemctl --user start river-session.target
''
