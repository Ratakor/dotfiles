{
  pkgs,
  lib,
  colors,
  vega,
  ...
}: {
  imports = [
    ./fonts.nix
    ./login.nix
    ./nix
    ./security.nix
    ./secrets.nix
  ];

  # Move that to users/ratakor/default.nix?
  users.users.ratakor = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    description = "Ratakor";
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
    # openssh.authorizedKeys.keys = [];
  };

  # TODO: setup a CI that update flake.lock once a week(?)
  system.autoUpgrade.enable = false;

  # Set your time zone
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      #   LC_ADDRESS = "fr_FR.UTF-8";
      #   LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      #   LC_MONETARY = "fr_FR.UTF-8";
      #   LC_NAME = "fr_FR.UTF-8";
      #   LC_NUMERIC = "fr_FR.UTF-8";
      #   LC_PAPER = "fr_FR.UTF-8";
      #   LC_TELEPHONE = "fr_FR.UTF-8";
      #   LC_TIME = "fr_FR.UTF-8";
    };
  };

  console.colors = with colors; [
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    bright_black
    bright_red
    bright_green
    bright_yellow
    bright_blue
    bright_magenta
    bright_cyan
    bright_white
  ];

  # TODO
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
      vega.pkgs.pmount # mount removable devices (see security.nix for setuid wrappers)

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

    # TODO: use that or `environment.variables`?
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # enable ozone wayland for chromium and electron based apps
    };

    variables = rec {
      EDITOR = "nvim";
      # VISUAL = "nvim";

      # https://github.con/NixOS/nixpkgs/issues/224525
      # TODO:
      # ~/.config/dconf/user
      # ~/.config/pulse/cookie
      # ~/.gnupg
      XDG_CONFIG_HOME = "$HOME/.local/etc";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.local/var/cache";
      XDG_STATE_HOME = "$HOME/.local/var/state";
      GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
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

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryPackage = pkgs.pinentry-curses;
    };

    gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];

    ssh = {
      # ssh client with gssapi support, also set in home-manager programs.ssh
      # and git (should it be only set system wide?)
      # package = pkgs.openssh_gssapi;
      startAgent = false; # handled by gnupg
    };
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
  };

  # this is for pmount
  systemd.tmpfiles.rules = [
    "d /media 0755 root root"
  ];
}
