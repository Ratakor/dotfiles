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
}
