{pkgs, ...}: {
  home.packages = with pkgs; [
    graphviz # graph visualization tool
    dragon-drop # a simple drag-and-drop replacement for graphical stuff

    qbittorrent # torrent client
    # krita # image editor
    # aseprite # pixel art editor
    # audacity # sound editor
    # gajim # XMPP client (see python-axolotl & python-gnupg)
    # anki # TODO: install + configure + which version?
  ];

  # TODO: I have no clue where to put that, and it's not configured, and it's
  # probably more complex than just pinentry since gpg-agent is all fucked up
  # since I keep having issue with git commit siging and ssh
  # services.gpg-agent.pinentry = {
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
}
