{
  imports = [
    ./packages.nix
    ./browsers.nix # TODO: merge with packages.nix
    # ./media.nix # TODO: merge with packages.nix
    ./git.nix # TODO: this shouldn't be here
    ./xdg.nix # TODO: this shouldn't be here

    ./terminal.nix
  ];
}
