{
  config,
  lib,
  pkgs,
  ...
}: {
  # TODO: triage packages that should be available system wide
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

    ## audio
    # rtkit
    # pipewire
    # pipewire-jack
    # pipewire-pulse
    # extra/wireplumber
    # bluez-openrc # bluetooth, rc-update add bluetoothd default
    # bluez-utils

    # TODO: overlay / custom packages
    # ## Ratakor's Cursed Packages (not really cursed tho)
    # rcp/pinentry-dmenu # use dmenu for gpg
    # aur/scron-git # simple cron daemon, spawn with crond # TODO: use systemd-timers
    # aur/dashbinsh # TODO: break things on nixos (?)
    # aur/quand-git # a calendar app like when
    # aur/zpotify # CLI for spotify
    # aur/2048.zig-bin
    # aur/neocities-zig-bin

    ## graphical
    # swayidle # idle manager # TODO: services
    wlopm # power management
    # #kanshi # multiple displays # TODO: services
    # claws-mail # mail client, use nonprism repo to remove libgdata support
    # gajim # XMPP client

    ## misc
    # less
    # curl
    # rsync

    # TODO: see man page nixos wiki
    # documentation.dev.enable = true;
    # mandoc
    man-pages man-pages-posix # Linux man pages

    # tlp-openrc # laptop power saving settings (rc-update add tlp default)
    # jq # json processor # TODO: programs.jq
    # yq # jq wrapper for yaml, xml and toml
    # checkbashisms
    # openbsd-netcat
    # noto-fonts-emoji # emoji font
    # noto-fonts-cjk
    # hunspell # dictionary for claws
    # hunspell-en_us
    # hunspell-fr
    # #python-axolotl # gajim dependency (removed from parabola repos)
    # python-gnupg # gajim dependency
    # git-lfs
    # perf
    # ntp-openrc # ntp client, rc-update add ntpd default
    # python-pipx
    # love
    # #clamav-openrc # antivirus (rc-update add clamd default) OUTDATED on parabola

    # innoextract # innoextract setup_warcraft_ii_2.02_v4_\(28734\).exe && wartool -v -r . ~/.stratagus/data.Wargus
    # #aur/stratagus
    # #aur/war1gus
    # wargus

    # TODO: from previous config
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

    # audio control
    #pavucontrol
    #playerctl
    #pulsemixer
    # services.playserctld.enable = true;
  ];

  # this is home-manager.programs not nixos.programs
  programs = {
    ssh = {
      enable = true;
      # TODO + this should be available system wide?
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
  };

  # TODO: enable these with systemd or something
  services = {
    # TODO: auto mount usb drives
    # udiskie.enable = true;

    # TODO
    # file sync
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
}
