{
  perSystem = {
    pkgs, # this has an overlay with all my packages btw
    self',
    ...
  }: let
    inherit (pkgs) callPackage;
  in {
    devShells = {
      default = self'.devShells.wrapped-config;
      dotfiles = callPackage ./dotfiles.nix {};
      wrapped-config = callPackage ./wrapped-config.nix {};
    };
  };
}
