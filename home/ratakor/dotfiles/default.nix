# TODO:
# - extract in modules (+ install packages lol)
# - use specific nixos config when possible
{
  imports = [
    ./etc.nix
    ./share.nix # TODO
    ./bin.nix
  ];
}
