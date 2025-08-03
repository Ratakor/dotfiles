{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    sc-im # spreadsheet
    iftop # display bandwidth usage
    simple-mtpfs # mount phone easily
    # gomuks # matrix client
    chafa # image in terminal
    caligula # TUI for burning disks
    pastel # CLI for color manipulation
    # glow # markdown viewer, imo bat or markview.nvim are better
    pmount # mount removable devices as normal user
    acpi # battery status, -i is good
    ytfzf # search youtube video without a browser
    imagemagick # image manipulation from the terminal
    mat2 # metadata removal tool
    bc # calculation
    termdown # timer on the terminal
    trash-cli # rm replacement kinda
    detox # cli to cleanup filenames
  ];

  programs = {
    # corrects your last command
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };

    # process viewer
    htop = {
      enable = true;
      package = pkgs.htop-vim;
      settings = {}; # TODO
    };

    # download any video/audio from the web
    yt-dlp = {
      enable = true;
      # TODO: config?
      # settings = {};
      # extraConfig = "";
    };

    # fuzzy finder
    fzf = {
      enable = true;
      # TODO: config?
    };

    fastfetch = {
      enable = true;
      # TODO: settings
    };
  };

  services = {
    # spotify client
    librespot = {
      enable = false; # TODO: org.freedesktop.systemd1.NoSuchUnit: Unit librespot.service not found.
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
  };
}
