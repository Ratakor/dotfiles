{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  home.packages = [
    (import ./music.nix {inherit config lib pkgs self;})
    (import ./musiccmd.nix {inherit config lib pkgs self;})
  ];
}
