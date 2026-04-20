{
  description = "Ratakor's basic NixOS configuration";

  # Nix configuration to use for this flake.
  # This doesn't affect the system configuration.
  nixConfig = {
    extra-substituters = [ "https://ratakor.cachix.org" ];
    extra-trusted-public-keys = [ "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0=" ];
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  inputs = {
    # Nixpkgs channels:
    # nixos-25.11 is the latest stable channel.
    # nixos-unstable is the rolling release channel for NixOS.
    # nixos-unstable-small is like nixos-unstable but with fewer binaries and more bleeding edge.
    # nixpkgs-unstable is the rolling release channel for Nix-as-a-package-manager.
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    # This allows building my packages on other platforms by overriding this input.
    systems.url = "github:nix-systems/x86_64-linux";

    # Flake builder.
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Configuration for the Thunderbird mail client.
    dove = {
      url = "git+https://gitlab.com/celenityy/Dove.git?ref=pages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
