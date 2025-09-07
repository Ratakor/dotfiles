{
  pkgs,
  self,
  ...
}: let
  wayland = {
    unsorted = with pkgs; [
      grim # screenshot
      slurp # region selection
      # swappy # image editor for screenshots
      wl-clipboard # clipboard management
      wf-recorder # screen recording
      swaybg # wallpaper utility
      wlopm # power management (black screen)
      swaylock # screen locker
    ];
  };

  # better to configure these with hm.programs, alse I use chromium btw
  browsers = with pkgs; [
    # firefox # check out celenityy/phoenix
    # nyxt # browser for lisp people
    # qutebrowser # "minimal" vim-like browser
  ];

  unsorted = with pkgs; [
    graphviz # graph visualization tool
    dragon-drop # a simple drag-and-drop replacement for graphical stuff

    qbittorrent # torrent client
    # krita # image editor
    # aseprite # pixel art editor
    # audacity # sound editor
    # gajim # XMPP client (see python-axolotl & python-gnupg)
    # anki # TODO: install + configure + which version?
    # obs-studio # screen recording and streaming

    keepassxc # Password manager
  ];
in [
  wayland.unsorted
  browsers
  unsorted
]
# config for swappy
#xdg.configFile."swappy/config".text = ''
#  [Default]
#  save_dir = ${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}
#  save_filename_format = swappy-%Y-%m-%d_%H:%M.png
#  show_panel = true
#'';

