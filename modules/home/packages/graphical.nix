# Graphical applications
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) attrValues concatLists;
  inherit (lib.lists) optionals singleton optional;

  sys = config.self.system;
  prg = config.self.programs;

  wayland = {
    apps = [ ];

    unsorted = with pkgs; [
      grim # screenshot
      slurp # region selection
      # swappy # image editor for screenshots # TODO: look into gabm/satty
      wl-clipboard # clipboard management
      wf-recorder # screen recording
      swaybg # wallpaper utility
      wlopm # power management (black screen)
      swaylock # screen locker
      # cage # Wayland kiosk that runs a single, maximized application
      wlr-randr # xrandr for wlroot
      # TODO: package wayclicker
    ];
  };

  # what about xorg-server and xorg-server-devel from archlinux?
  x11 = {
    # dmenu, dwm, sb, slock, st
    core = singleton pkgs.suckless;

    unsorted = with pkgs; [
      maim # screenshot
      slop # region selection
      xclip # clipboard management
      hsetroot # wallpaper utility
      xwallpaper # wallpaper utility for multiple monitors
      xorg.xrdb # Xresources
      # xbanish # hides mouse pointer while not in use
      xdo # window manipulation
      xclicker # gui autoclicker
      # oneko # cute cat that chases your mouse cursor
    ];
  };

  apps = concatLists [
    [
      # krita # image editor
      # pinta # second image editor
      # gimp # third image editor
      # aseprite # pixel art editor

      # blender # 3D modeling and animation
      # monero-gui # Monero wallet
      # teams-for-linux # Microsoft Teams
      # songrec # Open-source Shazam client
      # kiwix # # bruh why do I have the whole wikipedia locally installed
    ]
    (optional prg.apps.keepassxc.enable pkgs.keepassxc)
    (optional prg.apps.gajim.enable pkgs.gajim)
    (optional prg.apps.obs-studio.enable pkgs.obs-studio)
    (optional prg.apps.audacity.enable pkgs.audacity)
    (optional prg.apps.libreoffice.enable pkgs.libreoffice-fresh)
  ];

  tools = with pkgs; [
    graphviz # graph visualization tool
    dragon-drop # a simple drag-and-drop replacement for graphical stuff
    # scrcpy # display and control your Android device
    # network-printer # https://github.com/notashelf/np
  ];
in
[
  apps
  tools
]
++ optionals sys.displayServer.wayland (attrValues wayland)
++ optionals sys.displayServer.x11 (attrValues x11)
# |> optionals sys.video.enable
