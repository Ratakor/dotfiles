{
  pkgs,
  lib,
  username,
  ...
}: {
  # tests
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = false;
  };

  users.users = {
    root = {
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true; # TODO: remove
      # password = TODO
    };

    ${username} = {
      isNormalUser = true;
      description = username; # TODO: capitalize
      # group = username; # add "users" to extraGroups
      # password = TODO
      extraGroups = [
        "wheel"
        # "audio"
        # "video"
        # "storage"
        "network" "networkmanager"
        # "kvm"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true; # TODO: remove
      # openssh.authorizedKeys.keys = [];
    };
  };

  # customise /etc/nix/nix.conf declaratively via `nix.settings`
  nix.settings = {
    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = [username];

    # enable flakes globally
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      # TODO
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    builders-use-substitutes = true;

    # Optimize storage
    # You can also manually optimize the store via:
    #    nix-store --optimise
    # Refer to the following link for more details:
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    # auto-optimise-store = true;
  };

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "fr_FR.UTF-8";
  #   LC_IDENTIFICATION = "fr_FR.UTF-8";
  #   LC_MEASUREMENT = "fr_FR.UTF-8";
  #   LC_MONETARY = "fr_FR.UTF-8";
  #   LC_NAME = "fr_FR.UTF-8";
  #   LC_NUMERIC = "fr_FR.UTF-8";
  #   LC_PAPER = "fr_FR.UTF-8";
  #   LC_TELEPHONE = "fr_FR.UTF-8";
  #   LC_TIME = "fr_FR.UTF-8";
  # };

  # TODO: what is that
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # TODO: wrong fonts
  # sans-serif: Luciole
  # monospace: agave Nerd Font Mono
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      # noto-fonts-color-emoji

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.agave
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # TODO
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # TODO
  # Enable the OpenSSH daemon.
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     X11Forwarding = true;
  #     PermitRootLogin = "no"; # disable root login
  #     PasswordAuthentication = false; # disable password logind
  #   };
  #   openFirewall = true;
  # };

  environment = {
    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    # $ nix search <pkgname>
    systemPackages = with pkgs; [
      neovim # editor
      yazi # file manager
      zellij # terminal multiplexer (TODO: this one should probably be in home)
      zsh
      git
      wget
      curl

      cryptsetup
      #ntfs3g
      #xfsprogs xfsdump

      file
      which
      gnused
      gnutar
      gawk
      gnupg

      # TODO: these probably don't belong here
      sysstat
      lm_sensors
    ];

    shells = with pkgs; [
      dash
      zsh
    ];

    # binsh = "${pkgs.dash}/bin/dash"

    # Change ZDOTDIR in /etc/zshenv to not have a symlink in $HOME
    # TODO: this can probably be done in systemWide zsh config
    etc.zshenv = {
      text = "export ZDOTDIR=\"$HOME/.local/etc/zsh\"\n";
      # mode = "0655";
    };
  };

  programs.zsh.enable = true;

  # Enable sound with pipewire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # TODO: there is too much unrelated to audio stuff here
  # services.pulseaudio.enable = false;
  # serivces.power-profiles-daemon.enable = true;
  # security.polkit.enable = true;
  # services = {
  #   dbus.packages = [pkgs.gcr];

  #   geoclue2.enable = true;
  #
  #   pipewire = {
  #     enable = true;
  #     alsa.enable = true;
  #     alsa.support32Bit = true;
  #     pulse.enable = true;
  #     jack.enable = true;

  #     # media-session.enable = true;
  #   }

  #   udev.packages = with pkgs; [gnome-settings-daemon];
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security = {
    # TODO: or simply alias pmount to sudo pmount
    wrappers = {
      pmount = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.pmount}/bin/pmount";
      };
      pumount = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.pmount}/bin/pumount";
      };
    };

    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        # Preserve editor environment variables for visudo.
        Defaults!/usr/bin/visudo env_keep += "SUDO_EDITOR EDITOR VISUAL"

        Defaults lecture = never
        Defaults passwd_tries = 5
        Defaults passprompt = "sudo (%p@%h) password: "
      '';
      # extraRules = [];
    };
  };

  systemd.tmpfiles.rules = [
    "d /media 0755 ${username} users"
  ];

  documentation = {
    man = {
      man-db.enable = false;
      mandoc.enable = true;
      generateCaches = true;
    };
    dev.enable = true;
  };
}
