{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (builtins) attrValues;
  inherit (lib.lists) optionals;

  wayland = {
    apps = with pkgs; [
      # waydroid # Container-based approach to boot a full Android system on a regular GNU/Linux system
    ];

    unsorted = with pkgs; [
      grim # screenshot
      slurp # region selection
      # swappy # image editor for screenshots
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
    core = [ self.pkgs.suckless ];

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
    ];
  };

  # better to configure these with hm.programs, alse I use chromium btw
  browsers = with pkgs; [
    # firefox # check out celenityy/phoenix
    # nyxt # browser for lisp people
    # qutebrowser # "minimal" vim-like browser
    tor-browser
  ];

  apps = with pkgs; [
    keepassxc # password manager
    qbittorrent # torrent client
    # krita # image editor
    # pinta # second image editor
    # gimp # third image editor
    # aseprite # pixel art editor
    # audacity # sound editor
    # gajim # XMPP client (see python-axolotl & python-gnupg)
    # obs-studio # screen recording and streaming
    # libreoffice # office suite (there are many variant in nixpkgs)
    # blender # 3D modeling and animation
    # monero-gui # Monero wallet
    # teams-for-linux # Microsoft Teams
    # songrec # Open-source Shazam client
    # kiwix # # bruh why do I have the whole wikipedia locally installed
    discord # see vencord & vesktop too
    spotify
  ];

  unsorted = with pkgs; [
    graphviz # graph visualization tool
    dragon-drop # a simple drag-and-drop replacement for graphical stuff
    # scrcpy # display and control your Android device
    # oneko # cute cat that chases your mouse cursor
  ];
in
[
  browsers
  apps
  unsorted
]
++ optionals (config.self.displayServer == "wayland") (attrValues wayland)
++ optionals (config.self.displayServer == "x11") (attrValues x11)
