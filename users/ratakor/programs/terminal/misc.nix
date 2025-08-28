{
  config,
  pkgs,
  self,
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
    acpi # battery status, -i is good
    ytfzf # search youtube video without a browser
    imagemagick # image manipulation from the terminal
    mat2 # metadata removal tool
    bc # calculation
    termdown # timer on the terminal
    detox # cli to cleanup filenames
    yq # jq wrapper for yaml, xml and toml
    typos # spell checker
    # nmap # utility for network discovery and security auditing
    # aria2 #  lightweight, multi-protocol, multi-source command-line download utility
    # ipcalc # simple IP network calculator

    self.pkgs.zpotify # A CLI/TUI for Spotify
    self.pkgs.zig-2048 # 2048 game in terminal
  ];

  programs = {
    # corrects your last command
    pay-respects = {
      enable = false;
      enableZshIntegration = true; # adds the `f` alias
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

    fastfetch = {
      enable = true;
      # TODO: settings
    };

    # json processor
    jq = {
      enable = true;
    };

    # this should probably be somewhere else
    ssh = {
      enable = true;
      package = pkgs.openssh_gssapi; # use `null` for system default
      enableDefaultConfig = false; # deprecated
      matchBlocks = {
        "ssh.cri.epita.fr" = {
          extraOptions = {
            GSSAPIAuthentication = "yes";
            GSSAPIDelegateCredentials = "yes";
          };
        };
      };
    };
  };

  xdg.configFile."glow/glow.yml".text = ''
    # style name or JSON path (default "auto")
    style: "auto"
    # show local files only; no network (TUI-mode only)
    local: true
    # mouse support (TUI-mode only)
    mouse: true
    # use pager to display markdown
    pager: true
    # word-wrap at width
    width: 0 # 80
  '';

  xdg.configFile."ytfzf/conf.sh".text = ''
    video_pref=720p
    #show_thumbnails=1
    is_detach=1
    #is_loop=1
  '';
}
