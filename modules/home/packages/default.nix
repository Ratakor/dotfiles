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
  # Password managers
  password = singleton pkgs.keepassxc;
in {
  users.users.ratakor.packages = flatten (concatLists [
    dev
    terminal
    graphical
    password
  ]);
}
