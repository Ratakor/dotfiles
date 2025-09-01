{
  keys,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./console.nix
    ./fonts.nix
    ./login.nix
    ./networking.nix
    ./nix
    ./security.nix
    ./secrets.nix
    ./system.nix
  ];

  # Move that to users/ratakor/default.nix?
  users.users.ratakor = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    description = "Ratakor";
    # TODO: change to initialHashedPassword
    initialPassword = "password"; # very secure
    extraGroups = [
      "wheel"
      # "audio"
      # "video"
      # "storage"
      # "network"
      "networkmanager"
      # "kvm"
    ];
    openssh.authorizedKeys.keys = keys.ratakor;
  };

  environment = {
    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    # $ nix search nixpkgs <pkgname>
    # see `environment.defaultPackages` too
    # TODO: sort that
    systemPackages = with pkgs; [
      neovim # editor
      yazi # file manager
      git
      less
      wget
      curl
      rsync

      cryptsetup
      sysfsutils
      #ntfs3g
      #xfsprogs xfsdump
      killall
      dash
      gnupg
      pkg-config
      xdg-utils
      pmount # mount removable devices (see security.nix for setuid wrappers)

      ## system tools
      # sysstat
      lm_sensors # sensors
      pciutils # lspci
      usbutils # lsusb
      dnsutils # dig, host, nslookup
      brightnessctl # brightness control

      ## parabola base
      file
      findutils
      gawk
      gcc
      gettext
      glibc
      gnugrep
      gzip
      iproute2
      iputils
      procps
      psmisc
      gnused
      shadow
      gnutar
      util-linux
      xz

      ## parabola base-devel
      autoconf
      automake
      binutils
      bison
      debugedit
      fakeroot
      flex
      groff
      libtool
      m4
      gnumake
      patch
      pkgconf
      texinfo
      which

      ## Linux man pages
      man-pages
      man-pages-posix
    ];

    shells = with pkgs; [
      dash
      zsh
    ];

    variables = {
      EDITOR = "nvim";
    };

    # binsh = "${pkgs.dash}/bin/dash";
    localBinInPath = true;
    homeBinInPath = false;
    # memoryAllocator.provider = "graphene-hardened";
    enableAllTerminfo = false;
    enableDebugInfo = false; # see wiki to enable debug info per package instead
    extraOutputsToInstall = []; # enable it per package instead like `pkg.dev`
  };

  programs = {
    zsh.enable = true;

    # TODO
    # Window Manager
    river.enable = true;
    hyprland.enable = true;
    niri.enable = true;

    gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];
  };

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        # X11Forwarding = true;
        PermitRootLogin = "prohibit-password"; # disable root login with password
        PasswordAuthentication = false; # disable password login
      };
      openFirewall = true;
    };

    # Enable CUPS to print documents
    printing.enable = true;

    # Enable the X11 windowing system (still needed for wayland iirc)
    xserver.enable = true;

    # used by gammastep
    geoclue2.enable = true;

    # Whether to enable power-profiles-daemon, a DBus daemon that allows changing
    # system behavior based upon user-selected power profiles.
    power-profiles-daemon.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      # enable = true; # defaults to services.xserver.enable
    };

    # laptop power saving settings
    tlp = {
      enable = true;
      # settings ...
    };

    # Enable fprintd to use fingerprint readers
    fprintd.enable = true;

    # enable NTP client to sync time
    ntp.enable = true;

    # antivirus
    clamav = {
      # TODO
    };

    # Enable sound with pipewire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
      };
    };

    gnome = {
      # Disabled by default, but re-enabled by some packages:
      # niri: https://github.com/YaLTeR/niri/wiki/Important-Software#portals
      gnome-keyring.enable = lib.mkForce false;
      # gcr-ssh-agent.enable = false; # config.services.gnome.gnome-keyring.enable
    };

    # TODO: is userborn useful?
    userborn.enable = false;
  };

  # this is for pmount
  systemd.tmpfiles.rules = [
    "d /media 0755 root root"
  ];
}
