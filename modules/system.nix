{
  inputs,
  pkgs,
  lib,
  colors,
  ...
}: {
  imports = [
    ./secrets.nix
  ];

  users.users.ratakor = {
    isNormalUser = true;
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

  nix = {
    # remove nix-channel related tools & configs in favour of flakes
    channel.enable = false;

    # customise /etc/nix/nix.conf declaratively via `nix.settings`
    settings = {
      # given the users in this list the right to specify additional substituters via:
      #    1. `nixConfig.substituers` in `flake.nix`
      #    2. command line args `--options substituers http://xxx`
      trusted-users = ["@wheel"];

      # enable flakes globally
      experimental-features = ["nix-command" "flakes"];

      # TODO
      substituters = [
        # # cache mirror located in China
        # # status: https://mirror.sjtu.edu.cn/
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # # status: https://mirrors.ustc.edu.cn/status/
        # "https://mirrors.ustc.edu.cn/nix-channels/store"

        "https://cache.nixos.org"
        # "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
        # "https://nix-community.cachix.org"
        # "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      builders-use-substitutes = true;

      # TODO: useless with zfs dedup
      # Optimize storage
      # You can also manually optimize the store via:
      #    nix-store --optimise
      # Refer to the following link for more details:
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      # auto-optimise-store = true;
    };

    # Perform garbage collection weekly to maintain low disk usage
    # handled by programs.nh.clean
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 1w";
    # };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # TODO;
  system.autoUpgrade = {
    enable = false;
  };

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

  console.colors = [
    colors.black
    colors.red
    colors.green
    colors.yellow
    colors.blue
    colors.magenta
    colors.cyan
    colors.white
    colors.bright_black
    colors.bright_red
    colors.bright_green
    colors.bright_yellow
    colors.bright_blue
    colors.bright_magenta
    colors.bright_cyan
    colors.bright_white
  ];

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      # noto-fonts-monochrome-emoji
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
      luciole-fonts

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.agave
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Blobmoji" "Noto Color Emoji"];
      sansSerif = ["Luciole" "Noto Sans" "Blobmoji" "Noto Color Emoji"];
      monospace = ["Agave Nerd Font Mono" "Blobmoji" "Noto Color Emoji"];
      emoji = ["Blobmoji" "Noto Color Emoji"];
    };
  };

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

      ## system tools
      # sysstat
      lm_sensors # sensors
      pciutils # lspci
      usbutils # lsusb
      dnsutils # dig, host, nslookup

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

      ## secrets management
      inputs.agenix.packages.${system}.default
    ];

    shells = with pkgs; [
      dash
      zsh
    ];

    variables = {
      EDITOR = "nvim";
      # VISUAL = "nvim";
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
    hyprland.enable = false;
    river.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryPackage = pkgs.pinentry-curses;
    };

    # nix helper
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-size 7d";
        dates = "weekly";
      };
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

    # TODO
    # displayManager = {
    #   enable = true;
    #   # defaultSession = "none";
    #   # defaultSession = "none+river";
    #   autoLogin = {
    #     enable = true;
    #     user = "ratakor";
    #   };
    # };
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager = {
        lightdm.enable = false;
      };
    };

    # used by gammastep
    geoclue2.enable = true;

    # Whether to enable power-profiles-daemon, a DBus daemon that allows changing
    # system behavior based upon user-selected power profiles.
    power-profiles-daemon.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      # enable = true;
    };

    # laptop power saving settings
    tlp = {
      enable = true;
      # settings ...
    };

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
  };

  security = {
    rtkit.enable = true; # needed by pipewire

    pam.services.swaylock = {
      fprintAuth = false;
    };

    # https://github.com/NixOS/nixpkgs/pull/256491
    sudo-rs.enable = lib.mkForce false;

    sudo = {
      enable = true;

      # wheelNeedsPassword = false; # allow wheel group to run sudo without password
      execWheelOnly = true;

      extraConfig = ''
        Defaults env_keep += "EDITOR" # PATH DISPLAY
        Defaults lecture = never
        Defaults passprompt = "sudo (%p@%h) password: "
      '';

      extraRules = let
        mkNopassRule = command: {
          command = "/run/current-system/sw/bin/${command}";
          options = ["NOPASSWD"];
        };
      in [
        {
          groups = ["wheel"];
          commands = map mkNopassRule [
            # "nixos-rebuild"
            # "systemctl"
            "sync"
            "dmesg"
            "pmount"
            "pumount"
          ];
        }
      ];
    };
  };

  # this is for pmount
  # change user to root with mode 0775?
  systemd.tmpfiles.rules = [
    "d /media 0755 ratakor users"
  ];

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    man = {
      enable = true;
      man-db.enable = true;
      mandoc.enable = false; # sadly mandoc is poorly supported on nixos
      generateCaches = true;
    };
    nixos = {
      enable = true;
      # includeAllModules = true;
    };
  };
}
