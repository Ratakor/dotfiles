{
  imports = [
    ./fmt.nix # nix fmt
    ./lib # custom lib exposed by the flake
    ./packages # custom packages exposed by the flake
    # ./pre-commit.nix # pre-commit hooks
    ./shell.nix # nix develop
  ];
}
