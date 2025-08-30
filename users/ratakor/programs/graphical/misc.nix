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

    # anki # TODO: install + configure + which version?
  ];

  services = {
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

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir = ${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}
    save_filename_format = swappy-%Y-%m-%d_%H:%M.png
    show_panel = true
  '';
}
