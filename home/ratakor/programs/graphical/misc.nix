{
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
  ];

  programs = {
    # password manager (provides a cli version too)
    keepassxc = {
      enable = true;
      settings = {}; # TODO, -> password-manager.nix?
    };
  };
}
