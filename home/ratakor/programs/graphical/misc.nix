{
  colors,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    grim # screenshot
    slurp # region selection
    #swayppy # image editor for screenshots
    wl-clipboard # clipboard management
    wf-recorder # screen recording
    dragon-drop # a simple drag-and-drop replacement for graphical stuff
    qbittorrent # torrent client
    # krita # image editor
    # aseprite # pixel art editor
    # audacity # sound editor
    graphviz # graph visualization tool
    swaybg # wallpaper utility
    wlopm # power management (black screen)
    # claws-mail # mail client
    # gajim # XMPP client
    swayidle # idle manager (see services.swayidle)
  ];

  programs = {
    # password manager (provides a cli version too)
    keepassxc = {
      enable = true;
      settings = {}; # TODO, -> password-manager.nix?
    };
  };

  services = {
    # no blue light at night
    gammastep = {
      enable = true;
      settings.general.fade = 0;
      temperature.day = 6000;
      temperature.night = 3000;
      provider = "geoclue2";
      # provider = "manual";
      # latitude = 48.8;
      # longitude = 2.3;
    };

    # idle manager
    swayidle = {
      enable = true; # TODO: not started automatically when starting river (same for waybar)
      extraArgs = ["-w"];
      timeouts = [
        {
          timeout = 300;
          command = "glitchlock";
        }
        {
          timeout = 600;
          command = "${pkgs.wlopm}/bin/wlopm --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
        }
        # { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ];
    };

    # multiple displays
    kanshi = {
      # TODO
      enable = false;
    };

    # TODO
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

    # TODO?
    # auto mount usb drives
    udiskie = {
      enable = false;
    };
  };

  gtk = {
    theme = with colors.gtk; {
      inherit name;
      inherit package;
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
}
