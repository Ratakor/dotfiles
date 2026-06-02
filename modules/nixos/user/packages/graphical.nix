# Graphical applications
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (lib.lists) optionals optional;

  sys = config.self.system;
  prg = config.self.programs;

  apps = concatLists [
    (optional prg.apps.keepassxc.enable pkgs.keepassxc)
    (optional prg.apps.gajim.enable pkgs.gajim)
    (optional prg.apps.obs-studio.enable pkgs.obs-studio)
    (optional prg.apps.audacity.enable pkgs.audacity)
    (optional prg.apps.libreoffice.enable pkgs.libreoffice-fresh)
    (optional prg.apps.blender.enable pkgs.blender)
    (optional prg.apps.teams.enable pkgs.teams-for-linux)
    (optionals prg.apps.ledger-live.enable [
      pkgs.ledger-live-desktop
      pkgs.ledger-udev-rules # should this be in systemPackages?
    ])
  ];

  imageEditor = concatLists [
    (optional prg.imageEditor.aseprite.enable pkgs.aseprite)
    (optional prg.imageEditor.drawy.enable pkgs.drawy)
    (optional prg.imageEditor.gimp.enable pkgs.gimp)
    (optional prg.imageEditor.krita.enable pkgs.krita)
    (optional prg.imageEditor.pinta.enable pkgs.pinta)
  ];

  screenshot = with pkgs; [
    grim # screenshot
    slurp # region selection
    # swappy # image editor for screenshots # TODO: look into gabm/satty
  ];

  tools = with pkgs; [
    wl-clipboard # clipboard management
    wlopm # power management (black screen)
    # cage # Wayland kiosk that runs a single, maximized application
    wlr-randr # xrandr for wlroot
    # TODO: package wayclicker
    graphviz # graph visualization tool
    dragon-drop # a simple drag-and-drop replacement for graphical stuff
  ];

  unsorted = with pkgs; [
    wf-recorder # screen recording
    # scrcpy # display and control your Android device
    # network-printer # https://github.com/notashelf/np
    songrec # Open-source Shazam client (actual banger tbh)

    swaylock # screen locker (ik about prg.locker shut up)
    # monero-gui # Monero wallet
    # kiwix # bruh why do I have the whole wikipedia locally installed
  ];
in
{
  user.packages = optionals sys.video.enable (concatLists [
    apps
    imageEditor
    screenshot
    tools
    unsorted
  ]);
}
