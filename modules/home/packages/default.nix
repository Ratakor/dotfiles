{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (lib.lists) flatten;
  callPkgs = path: import path { inherit config lib pkgs; };

  # Development tools
  dev = callPkgs ./dev.nix;
  # Terminal applications
  terminal = callPkgs ./terminal.nix;
  # Graphical applications
  graphical = callPkgs ./graphical.nix;
  # Games
  games = callPkgs ./games.nix;
in
{
  user.packages = flatten (concatLists [
    dev
    terminal
    graphical
    games
  ]);
}
