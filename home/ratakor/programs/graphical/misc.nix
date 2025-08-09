{
  colors,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    grim # screenshot
    slurp # region selection
    # swayppy # image editor for screenshots
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
    # hunspell # spell checker (dictionary for claws)
    # hunspellDicts.en_US
    # hunspellDicts.fr-any
    # gajim # XMPP client (see python-axolotl & python-gnupg)
    swayidle # idle manager (see services.swayidle)

    # anki # TODO: install + configure + which version?
  ];

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

    # TODO: gnupg pinentry
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

    # auto mount usb drives
    udiskie = {
      enable = false; # TODO
      automount = true;
      notify = true;
      # TODO
      settings = {
        program_options = {
          terminal = "footclient -D";
        };
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      inherit (colors.gtk) name;
      package = pkgs.${colors.gtk.packageName};
    };

    gtk2.enable = false; # .gtkrc-2.0 symlink in $HOME

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

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir = ${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}
    save_filename_format = swappy-%Y-%m-%d_%H:%M.png
    show_panel = true
  '';
}
