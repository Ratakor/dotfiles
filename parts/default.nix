{ sources, ... }:
{
  imports = [
    ./apps # nix run
    ./fmt.nix # nix fmt
    ./lib # custom lib exposed by the flake
    ./pkgs # custom packages exposed by the flake
    # ./pre-commit.nix # pre-commit hooks
    ./templates # nix flake init -t FLAKE#TEMPLATE
  ];

  # Expose useful stuff to the flake outputs.
  # That also means that they can be referenced using `self`.
  flake = {
    inherit sources;
    keys = import ./keys.nix;
  };
}
