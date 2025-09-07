{
  imports = [
    ./args.nix # arguments overrides for flake-parts
    ./fmt.nix # nix fmt
    ./lib # custom lib exposed by the flake
    ./packages # custom packages exposed by the flake
    # ./pre-commit.nix # pre-commit hooks
    ./shells # nix develop
    ./templates # nix flake init -t FLAKE#TEMPLATE
  ];
}
