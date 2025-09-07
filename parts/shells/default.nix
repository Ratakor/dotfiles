{
  perSystem = {
    config,
    pkgs,
    self',
    ...
  }: let
    inherit (pkgs) callPackage;
  in {
    devShells = {
      default = self'.devShells.dotfiles;
      dotfiles = callPackage ./dotfiles.nix {inherit (self'.packages) agenix;};
    };
  };
}
