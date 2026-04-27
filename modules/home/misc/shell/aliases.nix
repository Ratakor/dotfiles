{ config, lib, ... }:
let
  sudoCommands = [
    "iftop"
    # "mount" # handled below
    "umount"
    "fdisk"
    "cryptsetup"
    "modprobe"
    "borgmatic"
    # "systemctl"
    # "nixos-rebuild"
    "sync"
    "dmesg"
  ];

  sudoAliases = builtins.listToAttrs (
    map (cmd: {
      name = cmd;
      value = "sudo ${cmd}";
    }) sudoCommands
  );

  EDITOR = lib.getExe config.self.programs.default.editor.package;
  ZDOTDIR = config.hm.programs.zsh.dotDir or "$HOME";
  XDG_CONFIG_HOME = config.hm.xdg.configHome;
  XDG_DATA_HOME = config.hm.xdg.dataHome;
  XDG_CACHE_HOME = config.hm.xdg.cacheHome;
  XDG_STATE_HOME = config.hm.xdg.stateHome;
  XDG_DOWNLOAD_DIR = config.hm.xdg.userDirs.download;
  XDG_DOCUMENTS_DIR = config.hm.xdg.userDirs.documents;
  XDG_MUSIC_DIR = config.hm.xdg.userDirs.music;
  XDG_PICTURES_DIR = config.hm.xdg.userDirs.pictures;
  XDG_VIDEOS_DIR = config.hm.xdg.userDirs.videos;
  XDG_BIN_DIR = config.hm.xdg.userDirs.extraConfig.BIN;
  XDG_SCREENSHOTS_DIR = config.hm.xdg.userDirs.extraConfig.SCREENSHOTS;
  XDG_NOTES_DIR = config.hm.xdg.userDirs.extraConfig.NOTES;
in
{
  hm.home.shellAliases = sudoAliases // {
    # edit config files and stuff
    cf = "cd ${XDG_CONFIG_HOME}";
    cfz = "${EDITOR} ${ZDOTDIR}/.zshrc";
    cfe = "${EDITOR} ${ZDOTDIR}/.zshenv";
    cfu = "${EDITOR} ${XDG_CONFIG_HOME}/newsboat/urls";
    dt = "cd ${XDG_DATA_HOME}";
    d = "cd ${XDG_DOWNLOAD_DIR}";
    D = "cd ${XDG_DOCUMENTS_DIR}";
    mm = "cd ${XDG_MUSIC_DIR}";
    mu = "cd ${XDG_MUSIC_DIR}/urls";
    pp = "cd ${XDG_PICTURES_DIR}";
    psc = "cd ${XDG_SCREENSHOTS_DIR}";
    vv = "cd ${XDG_VIDEOS_DIR}";
    wp = "cd ${XDG_PICTURES_DIR}/wallpapers";
    n = "yazi ${XDG_NOTES_DIR}";
    nn = "cd ${XDG_NOTES_DIR}";
    sc = "cd ${XDG_BIN_DIR}";
    sta = "cd ${XDG_STATE_HOME}";
    cac = "cd ${XDG_CACHE_HOME}";

    # shorter name and basic stuff changed
    e = "${EDITOR}";
    se = "sudoedit";
    sudo = "sudo "; # allows to run aliases with sudo
    ":q" = "exit";
    ":Q" = "exit";
    bc = "bc -ql";
    timer = "termdown";
    video-dlp = "ytdl v .";
    music-dlp = "ytdl m";
    playlist-dlp = "ytdl p";
    py = "python3";
    mount = "sudo mount -o nosuid,nodev,noexec";
    o = "plumber"; # o for open
    gb = "go build";
    zb = "zig build";
    cb = "cargo build";
    # cfmt = "astyle -A3 -t8 -p -xg -H -xB -U -n";
    gofmt = "gofmt -s -w";
    javafmt = "astyle --mode=java --style=google -n";
    fork = "setsid -f";
    zpot = "zpotify";
    z = "zellij --layout welcome";
    zac = "zellij attach --create";
    j = "just";
    # ask = "ollama run gemma3:12b --hidethinking"; # deepseek-r1:8b gemma3:12b
    ex = "ouch d";

    # <https://unix.stackexchange.com/a/81699>
    myip = "dig @resolver4.opendns.com myip.opendns.com +short";
    myip4 = "dig @resolver4.opendns.com myip.opendns.com +short -4";
    myip6 = "dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";

    # music
    pause = "musiccmd pause";
    play = "musiccmd play"; # This does the same thing as pause
    next = "musiccmd next";
    prev = "musiccmd prev";
    stop = "musiccmd stop";
    vol = "musiccmd volume"; # put the volume you want in arg like vol 50
  };

  # Aliases incompatible with Nushell.
  hm.programs = {
    zsh.shellAliases = {
      tmp = "cd $(mktemp -d)";
      timestamp = "date +%Y-%m-%dT%H:%M:%S%z";
    };
    nushell.extraConfig =
      # nu
      ''
        alias "tmp" = cd $"(mktemp -d)"
        def timestamp [] { date now | format date "%Y-%m-%dT%H:%M:%S%z" }
      '';
  };
}
