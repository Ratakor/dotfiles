{
  config,
  pkgs,
  ...
}: {
  user.packages = [
    (import ./music.nix {inherit config pkgs;})
    (import ./musiccmd.nix {inherit config pkgs;})
  ];
}
