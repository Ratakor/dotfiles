{
  pkgs,
  self,
  ...
}: let
  unsorted = with pkgs; [
    sc-im # spreadsheet
    iftop # display bandwidth usage
    simple-mtpfs # mount phone easily
    # gomuks # matrix client
    chafa # image in terminal
    caligula # TUI for burning disks
    pastel # CLI for color manipulation
    acpi # battery status, -i is good
    ytfzf # search youtube video without a browser
    imagemagick # image manipulation from the terminal
    mat2 # metadata removal tool
    bc # calculation
    termdown # timer on the terminal
    detox # cli to cleanup filenames
    yq # jq wrapper for yaml, xml and toml
    typos # spell checker
    # nmap # utility for network discovery and security auditing
    # aria2 #  lightweight, multi-protocol, multi-source command-line download utility
    # ipcalc # simple IP network calculator
    jq # json processor
    fastfetch # system information tool
    htop-vim # process viewer with vim keybindings
    fzf # fuzzy finder
    yt-dlp # download any video/audio from the web

    self.pkgs.zpotify # A CLI/TUI for Spotify
    self.pkgs.zig-2048 # 2048 game in terminal
    self.pkgs.zfs-restore # trash-restore but for ZFS snapshots
  ];
in [unsorted]
