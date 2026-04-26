{ pkgs, ... }:
let
  cli = with pkgs; [
    pastel # CLI for color manipulation
    acpi # battery status, -i is good
    yt-dlp # download any video/audio from the web
    jq # json processor
    yq # jq wrapper for yaml, xml and toml
    typos # spell checker
    detox # cli to cleanup filenames
    # xdg-ninja # Shell script which checks your $HOME for unwanted files and directories
    imagemagick # image manipulation from the terminal
    ffmpeg # video manipulation and a lot of other stuff
    mat2 # metadata removal tool
    bc # calculation
    libqalculate # better bc
    # shaq # CLI client for Shazam
    timewarrior # Time tracking utility
    rsync # a fast, versatile, remote (and local) file-copying tool
    zpotify # A CLI for the Spotify Web API
  ];

  tui = with pkgs; [
    sc-im # spreadsheet
    iftop # display bandwidth usage
    # gomuks # matrix client
    # iamb # Matrix Client
    fzf # fuzzy finder
    # htop-vim # process viewer with vim keybindings
    # micro # normie text editor
    # discordo # discord client
    # profanity # XMPP client (has security issue iirc)
    # spotify-player # zpotify but different
    wiremix # Audio mixer for PipeWire
    wrappers.btop # Monitor of resources
  ];

  # don't include that in packages
  rice = with pkgs; [
    fastfetch # system information tool
    cbonsai
    pipes
  ];

  # Chromecast tools
  cast = with pkgs.python313Packages; [
    casttube
    pychromecast
  ];

  ai = with pkgs; [
    gemini-cli # Google AI
    # copilot-cli # Microsoft AI
    # claude-code # Anthropic AI
    # ollama # My GPU is too old for this and I cba compiling it from scratch or using vulkan
  ];

  unsorted = with pkgs; [
    chafa # image in terminal
    caligula # TUI for burning disks
    ytfzf # search youtube video without a browser
    termdown # timer on the terminal
    # nmap # utility for network discovery and security auditing
    # aria2 #  lightweight, multi-protocol, multi-source command-line download utility
    # ipcalc # simple IP network calculator
    # ani-cli # CLI to browse and play anime
    # lxc # Userspace tools for Linux Containers, a lightweight virtualization system
    # dnsmasq #  Integrated DNS, DHCP and TFTP server for small networks
  ];
in
[
  cli
  tui
  # rice
  # cast
  ai
  unsorted
]
