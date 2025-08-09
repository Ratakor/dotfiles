# TODO: paliasrc
{
  colors,
  config,
  ...
}: let
  sudoCommands = [
    "iftop"
    # "mount" # handled below
    "umount"
    "pmount"
    "pumount"
    "fdisk"
    "cryptsetup"
    "modprobe"
    "su"
    "visudo"
    "borgmatic"
  ];

  sudoAliases = builtins.listToAttrs (
    map (cmd: {
      name = cmd;
      value = "sudo ${cmd}";
    })
    sudoCommands
  );

  XDG_CONFIG_HOME = config.xdg.configHome;
  XDG_DATA_HOME = config.xdg.dataHome;
  XDG_CACHE_HOME = config.xdg.cacheHome;
  XDG_STATE_HOME = config.xdg.stateHome;
in {
  home.shellAliases =
    sudoAliases
    // {
      # edit config files and stuff
      cf = "cd ${XDG_CONFIG_HOME}";
      cfv = "cd ${XDG_CONFIG_HOME}/nvim";
      cfy = "cd ${XDG_CONFIG_HOME}/yazi";
      cfz = "$EDITOR $ZDOTDIR/.zshrc";
      cfe = "$EDITOR $ZDOTDIR/.zshenv";
      cfa = "$EDITOR $ZDOTDIR/aliasrc";
      cfr = "$EDITOR ${XDG_CONFIG_HOME}/river/init";
      cfn = "$EDITOR ${XDG_CONFIG_HOME}/newsboat/config";
      cfu = "$EDITOR ${XDG_CONFIG_HOME}/newsboat/urls";
      cfq = "$EDITOR ${XDG_CONFIG_HOME}/quand/config";
      cfb = "cd ${XDG_CONFIG_HOME}/waybar";
      cft = "$EDITOR ${XDG_CONFIG_HOME}/foot/foot.ini";
      cfc = "$EDITOR ${XDG_CONFIG_HOME}/crontab";
      dt = "cd ${XDG_DATA_HOME}";
      pkg = "$EDITOR ${XDG_DATA_HOME}/packages";
      d = "cd $XDG_DOWNLOAD_DIR";
      D = "cd $XDG_DOCUMENTS_DIR";
      mm = "cd $XDG_MUSIC_DIR";
      mu = "cd $XDG_MUSIC_DIR/urls";
      pp = "cd $XDG_PICTURES_DIR";
      psc = "cd $XDG_PICTURES_DIR/screenshots";
      vv = "cd $XDG_VIDEOS_DIR";
      wp = "cd $XDG_PICTURES_DIR/wallpapers";
      n = "yazi $XDG_DOCUMENTS_DIR/notes";
      nn = "cd $XDG_DOCUMENTS_DIR/notes";
      sc = "cd $HOME/.local/bin";
      sta = "cd ${XDG_STATE_HOME}";
      cac = "cd ${XDG_CACHE_HOME}";

      # shorter name and basic stuff changed
      e = "$EDITOR";
      se = "sudoedit";
      sudo = "sudo "; # allows to run aliases with sudo
      sudoers = "visudo --strict";
      ":q" = "exit";
      ":Q" = "exit";
      bc = "bc -ql";
      timer = "termdown";
      video-dlp = "ytdl v .";
      music-dlp = "ytdl m";
      playlist-dlp = "ytdl p";
      py = "python3";
      # ho = "cat ${XDG_DATA_HOME}/hole/history";
      tmp = "cd $(mktemp -d)";
      mount = "sudo mount -o nosuid,nodev,noexec";
      o = "plumber"; # o for open
      gb = "go build";
      zb = "zig build";
      cb = "cargo build";
      g = "grep -RIn --exclude-dir=.git";
      cfmt = "astyle -A3 -t8 -p -xg -H -xB -U -n";
      gofmt = "gofmt -s -w";
      javafmt = "astyle --mode=java --style=google -n";
      fork = "setsid -f";
      # zigup = "zigup --install-dir $XDG_DATA_HOME/zigup --path-link $HOME/.local/bin/zig";
      zpot = "zpotify";
      z = "zellij --layout welcome";
      zac = "zellij attach --create";
      timestamp = "date +%Y-%m-%dT%H:%M:%S%z";

      # verbosity and colors
      rm = "trash -v"; # "rm -vI"
      rmdir = "rmdir -v"; # -p
      cp = "cp -riv"; # --reflink=always
      mv = "mv -iv";
      mkdir = "mkdir -pv";
      grep = "grep --color=always -n";
      diff = "diff --color=always";
      ip = "ip --color=always";
      ls = "eza --color=always --group-directories-first --hyperlink";
      sl = "ls";
      ll = "ls -lho --git";
      la = "ls -a";
      laa = "ls -aa";
      l = "ls -lhoa";
      lr = "ls -R";
      tree = "ls -T";
      cat = "bat --style=numbers,changes --tabs 8"; # --theme=${colors.theme}";
      du = "dust -r";
      duf = "duf -hide special";
      fd = "fd -HI --color=always";
      less = "less -R";

      # git
      G = "gitui";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gca = "git commit --all";
      gcv = "git commit --verbose";
      gcm = "git commit --message";
      gam = "git commit --amend";
      gp = "git push --follow-tags"; # --tags
      gpl = "git pull";
      gr = "git restore";
      grs = "git restore --staged";
      gd = "git diff";
      gac = "ga . && gc";
      gacv = "ga . && gcv";
      gcp = "gc && gp";
      gacp = "ga . && gc && gp";
      gacpv = "ga . && gcv && gp";

      # music
      pause = "musiccmd pause";
      play = "musiccmd play"; # This does the same thing as pause
      next = "musiccmd next";
      prev = "musiccmd prev";
      stop = "musiccmd stop";
      vol = "musiccmd volume"; # put the volume you want in arg like vol 50

      # # convert markdown to pdf with pandoc
      # function pdfmd() {
      #     pandoc "$1" -o "$(printf '%s' "$1" | sed 's/.md/.pdf/g')" # -V geometry:margin=1in
      # }
    };
}
