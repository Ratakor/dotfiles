{
  description = "Ratakor's basic NixOS configuration";

  # Additional binary caches to use for this flake.
  # This doesn't affect the system configuration.
  nixConfig = {
    extra-substituters = ["https://ratakor.cachix.org"];
    extra-trusted-public-keys = ["ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0="];
  };

  inputs = {
    # Nixpkgs channels:
    # nixos-25.05 is the latest stable channel.
    # nixos-unstable is the rolling release channel for NixOS.
    # nixos-unstable-small is like nixos-unstable but with fewer binaries.
    # nixpkgs-unstable is the rolling release channel for Nix-as-a-package-manager.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # We only care about x86_64-linux (for now).
    systems.url = "github:nix-systems/x86_64-linux";

    # Flake builder.
    flake-parts.url = "github:hercules-ci/flake-parts";

    # This is not a dotfiles manager it's a whole kitchen sink to manage
    # home configurations, hjem or basic stow implementation might be better
    # for raw dotfiles. Note that there is a stable version of home-manager.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Zig programming language.
    zig = {
      url = "github:silversquirl/zig-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      # Systems for which attributes of `perSystem` will be built.
      systems = import inputs.systems;

      imports = [
        ./parts
        ./hosts
      ];
    };
}
