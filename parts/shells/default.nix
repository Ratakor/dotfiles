{
  perSystem =
    {
      pkgs, # this has an overlay with all my packages btw
      self',
      ...
    }:
    let
      inherit (pkgs) callPackage;
    in
    {
      devShells = {
        default = self'.devShells.dotfiles;
        dotfiles = callPackage ./dotfiles.nix { };
      };
    };
}
