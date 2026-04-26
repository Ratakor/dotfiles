{ lib, sources, ... }:
{
  imports = [
    ./apps # nix run
    ./fmt.nix # nix fmt
    ./pkgs # custom packages exposed by the flake
    # ./pre-commit.nix # pre-commit hooks
    ./templates # nix flake init -t FLAKE#TEMPLATE
  ];

  # Expose useful stuff to the flake outputs.
  # That also means that they can be referenced using `self`.
  flake = {
    inherit lib sources;
    keys = import ./keys.nix;
  };
}
