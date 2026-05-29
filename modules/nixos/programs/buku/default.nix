# Bookmarks Manager
# https://github.com/jarun/buku
{ lib, pkgs, ... }:
{
  config = lib.mkIf true {
    user.packages = [ pkgs.buku ];

    # TODO: bukuserver
    # https://github.com/jarun/buku/wiki/Bukuserver-(WebUI)
    #

    # buku -p -f10 | fzf --reverse

    # TODO: setupt sync between hosts
    # new syncthing entry or perdically via -e
  };
}
