{
  config,
  lib,
  pkgs,
  ...
}: {
  # TODO: triage packages that should be available system wide
  # TODO: make colors & theme (gruvbox) parameters
  home.packages = with pkgs; [
    ## base Parabola OpenRC
    # base (bash bzip2 coreutils esysusers etmpfiles file findutils gawk gcc-libs gettext glibc grep gzip iproute2 iputils pciutils procps-ng psmisc sed shadow tar util-linux xz)
    # base-devel (autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf sed sudo texinfo which)
    # linux-libre
    # networkmanager-openrc
    # inetutils
    # grub
    # dbus-openrc
    # openssh
    #
    # TODO: overlay / custom packages
    # ## Ratakor's Cursed Packages (not really cursed tho)
    gitui # TODO: use 0.22.1? setup config with programs.gitui?
    # rcp/pinentry-dmenu # use dmenu for gpg
    # aur/scron-git # simple cron daemon, spawn with crond # TODO: use systemd-timers
    # aur/dashbinsh # TODO: break things on nixos (?)
    # aur/quand-git # a calendar app like when
    # aur/zpotify # CLI for spotify
    # aur/2048.zig-bin
    # aur/neocities-zig-bin

    ## terminal
    newsboat # RSS Reader
    eza # ls replacement # TODO: programs.eza
    ripgrep # grep replacement
    # poppler # yazi dependency
    # mediainfo # yazi dependency
    # ffmpegthumbnailer # yazi dependency
    yt-dlp # download any video/audio from the web
    ytfzf # search youtube video without a browser
    dust # du replacement
    duf # df replacement
    fd # find replacement
    zellij # terminal multiplexer & session manager
    senpai # IRC client

    ## dev
    # texlive # LaTeX (big package)
    pandoc # Conversion between documentation formats
    rustup # rust
    nasm # x86 compiler
    gcc # gnu compiler collection
    # clang # another cc + clangd C lsp
    tinycc # tiny c compiler
    # mingw-w64-gcc # windows cc
    # musl # another libc
    # libbsd
    # aur/zigup-bin # TODO: use zig-overlay? (zigup not in nix repos)
    go
    python3
    # astyle # C formatter
    # shellcheck
    # cmake
    # gdb
    # qemu-full
    # dosfstools
    # mtools
    # xorriso
    # gptfdisk
    # jdk17-openjdk
    poop # Performance Optimizer Observation Platform
    # TODO: vimPlugins.nvim-treesitter-parsers.superhtml?
    superhtml # html LSP
    # nodejs
    nodePackages.npm
    nodePackages.pnpm
    lua
    luarocks
    # just # command runner
    #
    # ## audio
    # rtkit
    # pipewire
    # pipewire-jack
    # pipewire-pulse
    # extra/wireplumber
    # bluez-openrc # bluetooth, rc-update add bluetoothd default
    # bluez-utils

    ## grapical
    river # window manager
    waybar # bar
    foot # terminal emulator
    # swaybg # wallpaper utility
    grim # screenshot
    slurp # region selection
     #swappy # image editor for screenshots
    # swayidle # idle manager
    wlopm # power management
    wl-clipboard # clipboard management
    wf-recorder # screen recording
    # #kanshi # multiple displays
    # mpv # video and music player
    # socat # dependency for the music script that uses mpv
    # claws-mail # mail client, use nonprism repo to remove libgdata support
    # gajim # XMPP client

    ## archives
    zip
    xz
    unzip
    p7zip
    zstd
    lz4
    ouch # Obvious Unified Compression Helper

    ## misc
    # less
    keepassxc # password manager
    # curl
    # rsync
    # syncthing # file sync
    borgbackup # backup tool
    borgmatic # borg wrapper
    fzf
    imagemagick # image manipulation from the terminal
    mat2 # metadata removal tool

    # TODO: see man page nixos wiki
    # documentation.dev.enable = true;
    # mandoc
    man-pages man-pages-posix # Linux man pages

    # sshfs # mount drive over ssh
    bc # calculation
    # tlp-openrc # laptop power saving settings (rc-update add tlp default)
    ntfs3g # ntfs filesystem (windows compatibility)
    xfsprogs xfsdump # xfs filesystem
    termdown # timer on the terminal
    fastfetch
    # jq # json processor # TODO: programs.jq
    # yq # jq wrapper for yaml, xml and toml
    # krita # image editor
    # aseprite # pixel art editor
    # audacity
    qbittorrent # torrent client
    # checkbashisms
    # dash # sh replacement
    # python-pynvim # neovim dependency
    # #nyxt # browser for lisp people
    # #qutebrowser # parabola still ship the QtWebKit version :(
    # openbsd-netcat
    # noto-fonts-emoji # emoji font
    # noto-fonts-cjk
    # hunspell # dictionary for claws
    # hunspell-en_us
    # hunspell-fr
    # #python-axolotl # gajim dependency (removed from parabola repos)
    # python-gnupg # gajim dependency
    # git-lfs
    zsh-completions nix-zsh-completions # TODO: should this be system wide or somewhere else?
    cloc
    # perf
    graphviz
    trash-cli
    # ntp-openrc # ntp client, rc-update add ntpd default
    detox # cli to cleanup filenames
    # python-pipx
    sc-im # spreadsheet
    htop-vim # process viewer (htop) with vim keybinds
    iftop # display bandwidth usage
    simple-mtpfs # mount phone easily
    dragon-drop # a simple drag-and-drop replacement for graphical stuff
    # gomuks # matrix client
    chafa # image in terminal
    # love
    caligula # TUI for burning disks
    pastel # CLI for color manipulation
    # #clamav-openrc # antivirus (rc-update add clamd default) OUTDATED on parabola
    # #glow # markdown viewer, imo bat or markview.nvim are better
    pmount # mount removable devices as normal user, greatest software in existence
    acpi # battery status, -i is good

    # innoextract # innoextract setup_warcraft_ii_2.02_v4_\(28734\).exe && wartool -v -r . ~/.stratagus/data.Wargus
    # #aur/stratagus
    # #aur/war1gus
    # wargus

    # TODO: from previous config
    libnotify
    wineWowPackages.wayland
    xdg-utils

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # nix related
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # this is home-manager.programs not nixos.programs
  programs = {
    ssh = {
      enable = true;
      # TODO + this should be available system wide?
    };

    # editor
    neovim = {
      enable = true;
      # TODO
    };

    # user shell
    zsh = {
      enable = true;
      # TODO
      dotDir = "${config.xdg.configHome}/zsh-nix";
      # extra...
      # sessionVariables = {};
      # setOptions = [];
      # shellAliases = {};
      # shellGlobalAliases = {};
    };

    # cat replacement
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        style = "plain";
        tabs = "0";
      };
    };

    # file manager
    yazi = {
      enable = true;
      plugins = with pkgs.yaziPlugins; {
        inherit ouch;
        inherit bypass;
        inherit toggle-pane;
        inherit mediainfo;
      };
    };

    # cd replacement
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableZshIntegration = true;
    };

    # corrects your last command
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };

    # TODO
    # skim = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   defaultCommand = "rg --files --hidden";
    #   changeDirWidgetOptions = [
    #     "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
    #     "--exact"
    #   ];
    # };

    # image viewer
    imv = {
      enable = true;
      # package = # TODO: use git version: v4.5.0 doesn't work with gifs
      settings.binds = {
        n = "next";
        p = "prev";
        "<Ctrl+p>" = "exec echo $imv_current_file";
      };
    };

    # screen locker
    swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        ignore-empty-password = true;
        show-failed-attempt = true;
        indicator-caps-lock = true;
        indicator-radius = 100;
        font = "monospace";
        scaling = "fill";
        # TODO: colors
      };
    };

    # dynamic menu
    tofi = {
      enable = true;
      package = pkgs.tofi.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [./tofi-dmenu-20240910.diff];
      });
      settings = {
        width = "100%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        padding-left = "33%";
        padding-top = "33%";
        result-spacing = 5;
        num-results = 10;
        font = "monospace";
        require-match = false;
        # TODO: colors
        background-color = "#000a";
        text-color = "#ebdbb2";
        selection-color = "#689d6a";
      };
    };

    # document viewer
    zathura = {
      enable = true;
      options = {
        statusbar-h-padding = 0;
        statusbar-v-padding = 0;
        page-padding = 1;
        selection-clipboard = "clipboard";
        window-title-basename = true;
        statusbar-basename = true;
      };
      mappings = {
        i = "recolor";
        p = "print";
        w = "adjust_window width";
        W = "adjust_window best-fit";
      };
    };

    # TODO
    # terminal multiplexer & session manager
    # zellij = {
    #   enable = true;
    #   # package = # TODO: patch for zsh completions
    #   enableZshIntegration = true;
    #   settings = {
    #     theme = "gruvbox-dark";
    #     show_startup_tips = false;
    #     # pane_frames = false;
    #     # simplified_ui = true;
    #     # default_layout = "compact";

    #     # keybinds = {
    #     #   session
    #     # };
    #   };
    # };
  };

  # TODO: enable these with systemd or something
  services = {
    # TODO: auto mount usb drives
    # udiskie.enable = true;

    # TODO
    syncthing = {
      enable = false;
      # overrideDevices = false;
      # overrideFolders = false;
      # settings = {
      #   devices = {}; # TODO
      #   folders = {}; # TODO
      #   options = {}; # TODO
      # };
    };

    # no blue light at night
    gammastep = {
      enable = true;
      settings.general.fade = 0;
      temperature.night = 3000;
      # TODO: use geoclue2
      provider = "manual";
      latitude = 48.8;
      longitude = 2.3;
    };

    # spotify client
    librespot = {
      enable = false; # TODO
      # https://github.com/librespot-org/librespot/wiki/Options
      settings = {
        quiet = true;
        autoplay = "on";
        enable-volume-normalisation = true;
        name = "librespot"; # TODO: "librespot@$(hostname)";
        bitrate = 320;
        format = "F32";
        backend = "pulseaudio";
        enable-oauth = true;
        initial-volume = 100;
        volume-ctrl = "fixed";
      };
    };

    # notification daemon
    mako = {
      enable = true;
      settings = {
        width = 350;
        height = 400;
        border-size = 2;
        default-timeout = 5000;
        font = "monospace";
        max-icon-size = 32;
        #on-button-middle=exec makoctl menu -n "$id" "$MENU" -p "Select action:"

        # TODO: colors (e6 is alpha btw)
        background-color = "#282828" + "e6";
        text-color = "#ebdbb2" + "e6";
        border-color = "#689d6a" + "e6";
      };
      extraConfig = ''
        [urgency=low]
        border-color=#98971ae6

        [urgency=high]
        border-color=#cc241de6
        default-timeout=0
      '';
    };

    # gpg-agent.pinentry = {
    #   package = pkgs.pinentry-dmenu.overrideAttrs (oldAttrs: rec {
    #     version = "460fde704079c3791294d13a60a03069426e7f82";
    #     src = pkgs.fetchFromGithub {
    #       owner = "ratakor";
    #       repo = "pinentry-dmenu";
    #       tag = version;
    #       hash = "";
    #     };
    #   });
    #   program = "pinentry-dmenu";
    # };
  };

  # TODO: shouldn't be here
  gtk = {
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };

    gtk3.extraCss = ''
      /* No (default) titlebar on wayland */
      .titlebar, .css, headerbar {
          background-image:none;
          background-color: transparent;
          margin-top: -100px;
          margin-bottom: 50px;
      }
    '';
  };

  wayland.windowManager.river = {
    enable = true;
  };
}
