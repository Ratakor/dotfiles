{
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) concatLists;
  inherit (lib.lists) singleton flatten;
  callPkgs = path: import path {inherit pkgs self;};

  # Development tools
  dev = callPkgs ./dev.nix;
  # Terminal applications
  terminal = callPkgs ./terminal.nix;
  # Graphical applications
  graphical = callPkgs ./graphical.nix;
in {
  user.packages = flatten (concatLists [
    dev
    terminal
    graphical
  ]);
}
