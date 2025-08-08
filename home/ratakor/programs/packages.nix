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
    # inetutils
    # openssh

    # TODO: overlay / custom packages (add ~/.local/bin scripts too for stuff like "${...}/bin/randwp")
    # aur/scron-git # simple cron daemon, spawn with crond # TODO: use systemd-timers
    # aur/quand-git # a calendar app like when
    # rcp/pinentry-dmenu # use dmenu for gpg
    # aur/neocities-zig-bin
    # anki idk which version (move to latest maybe lol?)

    ## misc
    # less
    # curl
    # rsync
    autoconf
    automake
    libtool
    pkg-config

    # perf # perf-linux?
    # ntp-openrc # ntp client, rc-update add ntpd default
    # python-pipx
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
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

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

    # TODO: fzf replacement
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
}
