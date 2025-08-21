{
  description = "Ratakor's basic NixOS configuration";

  inputs = {
    # Nixpkgs channels:
    # nixos-stable is the latest LTS channel.
    # nixos-unstable is the rolling release channel for NixOS.
    # nixos-unstable-small is like nixos-unstable but with a smaller set of packages.
    # nixpkgs-unstable is the rolling release channel for Nix-as-a-package-manager.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # The actual nixpkgs channels we use.
    nixpkgs.follows = "nixos-unstable";
    nixpkgs-small.follows = "nixos-unstable-small";

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

    # Secrets management.
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        home-manager.follows = "home-manager";
        darwin.follows = "";
        systems.follows = "systems";
      };
    };

    # Formatter multiplexer.
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # Nixpkgs lib & packages extension.
    vega = {
      url = ./vega;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };

    # This take 900MB on /nix/store btw.
    wallpapers = {
      url = "github:ratakor/wallpapers";
      flake = false;
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
