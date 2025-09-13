{
  description = "Ratakor's basic NixOS configuration";

  # Nix configuration to use for this flake.
  # This doesn't affect the system configuration.
  nixConfig = {
    extra-substituters = [ "https://ratakor.cachix.org" ];
    extra-trusted-public-keys = [ "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0=" ];
    experimental-features = [ "flakes" "nix-command" "pipe-operators" ];
  };

  inputs = {
    # Nixpkgs channels:
    # nixos-25.05 is the latest stable channel.
    # nixos-unstable is the rolling release channel for NixOS.
    # nixos-unstable-small is like nixos-unstable but with fewer binaries.
    # nixpkgs-unstable is the rolling release channel for Nix-as-a-package-manager.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # This allows building my packages on other platforms by overriding this input.
    systems.url = "github:nix-systems/x86_64-linux";

    # Flake builder.
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # Systems for which attributes of `perSystem` will be built.
      systems = import inputs.systems;

      imports = [
        ./parts
        ./hosts
      ];
    };
}
