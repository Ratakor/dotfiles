# Terminal applications
# TODO: this is bloated
{ config, pkgs, ... }:
let
  inherit (builtins) concatLists;

  sys = config.self.system;

  cli = with pkgs; [
    pastel # CLI for color manipulation
    acpi # battery status, -i is good
    yt-dlp # download any video/audio from the web
    jq # json processor
    yq # jq wrapper for yaml, xml and toml
    typos # spell checker
    detox # cli to cleanup filenames
    # xdg-ninja # Shell script which checks your $HOME for unwanted files and directories
    bc # calculation
    libqalculate # better bc
    # shaq # CLI client for Shazam
    timewarrior # Time tracking utility
    rsync # a fast, versatile, remote (and local) file-copying tool
    croc # Easily and securely send things from one computer to another
    playerctl # CLI for controlling media players that implement MPRIS
    curd # CLI to browse and play anime, see also ani-cli
    # dumbpipe # Unix pipes between devices
    # sendme # A tool to send files and directories
  ];

  tui = with pkgs; [
    sc-im # spreadsheet
    iftop # display bandwidth usage
    # gomuks # matrix client
    # iamb # Matrix Client
    fzf # fuzzy finder
    # htop-vim # process viewer with vim keybindings
    # discordo # discord client
    # profanity # XMPP client
    # spotify-player # zpotify but different
    wiremix # Audio mixer for PipeWire
    wrappers.btop # Monitor of resources
    caligula # TUI for burning disks
    wrappers.scooter # Interactive file-and-replace on files
  ];

  image = with pkgs; [
    imagemagick # image manipulation from the terminal
    ffmpeg # video manipulation and a lot of other stuff, see also ffmpeg-full
    mat2 # metadata removal tool
    oxipng # PNG compression optimizer
    libwebp # Tools and library for the WebP image format (cwebp/dwebp)
  ];

  # don't include that in packages
  rice = with pkgs; [
    fastfetch # system information tool
    cbonsai
    pipes
    cmatrix
  ];

  # Chromecast tools
  cast = with pkgs.python313Packages; [
    casttube
    pychromecast
  ];

  ai = with pkgs; [
    antigravity-cli # Google (agy)
    # claude-code # Anthropic
    # codex # OpenAI
    # herdr # Agent multiplexer
  ];

  fs = with pkgs; [
    cryptsetup
    # mtools # Utilities to access MS-DOS disks
    # libisoburn # xorriso
    # gptfdisk
    sshfs # mount drive over ssh
    # xfsdump # xfs snapshots
    simple-mtpfs # mount phone easily
    zfs-restore # trash-restore but for ZFS snapshots
    smartmontools # Tools for monitoring the health of hard drives
  ];

  archives = with pkgs; [
    ouch-rar # Obvious Unified Compression Helper
    # mpack # encode / decode binary files in MIME (like RFC 822 mail)
    # bzip2
    # gzip
    # zip
    # unzip
    # p7zip
    # xz
    # zstd
    # lz4
    # gnutar
  ];

  # Anilist & co interface
  # TODO: see inotify for media recognition tracking
  trackma = [
    (pkgs.trackma.override {
      withCurses = true;
      withGTK = sys.video.enable;
      withQT = false; # sys.video.enable;
    })
  ];

  scripts = with pkgs.scripts; [
    real
    sci
    ytdl
    # pdfmd # 1GB of dependencies (pandoc)

    # TODO: support archive/compressed files? (ouch is already goated)
    # TODO: override prelude? (also in yazi, maybe as a nixpkgs overlay)
    plumber
  ];

  unsorted = with pkgs; [
    chafa # image in terminal
    # ytfzf # search youtube video without a browser
    termdown # timer on the terminal
    # nmap # utility for network discovery and security auditing
    # aria2 #  lightweight, multi-protocol, multi-source command-line download utility
    # ipcalc # simple IP network calculator
    # lxc # Userspace tools for Linux Containers, a lightweight virtualization system
    # dnsmasq #  Integrated DNS, DHCP and TFTP server for small networks
  ];
in
{
  user.packages = concatLists [
    cli
    tui
    image
    # rice
    # cast
    ai
    fs
    archives
    # trackma
    scripts
    unsorted
  ];
}
