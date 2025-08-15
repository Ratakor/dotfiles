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

    # zig2nix dependency
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # custom zig packages dependency
    zig2nix = {
      url = "github:Cloudef/zig2nix";
      inputs.nixpkgs.follows = "nixpkgs-small";
      inputs.flake-utils.follows = "flake-utils";
    };

    ## custom packages
    zig-2048 = {
      url = "github:ratakor/2048.zig";
      inputs.zig2nix.follows = "zig2nix";
    };

    zpotify = {
      url = "github:ratakor/zpotify";
      inputs.zig2nix.follows = "zig2nix";
    };

    wallpapers = {
      url = "github:ratakor/wallpapers";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    theme = "gruvbox-dark"; # gruvbox-dark gruvbox-light dracula
  in {
    nixosConfigurations = {
      X200 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          colors = (import ./modules/colors).${theme};
          muhlib = import ./lib {pkgs = nixpkgs;};
        };

        modules = [
          ./hosts/X200

          (import ./overlays)

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = inputs // specialArgs;
              backupFileExtension = "hm.bak";
              users.ratakor = import ./home/ratakor;
            };
          }

          inputs.agenix.nixosModules.default
        ];
      };
    };
  };
}
