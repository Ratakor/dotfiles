{
  description = "NixOS configuration";

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs-small";
        home-manager.follows = "home-manager";
        darwin.follows = "";
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
    nixpkgs-stable,
    home-manager,
    agenix,
    ...
  } @ inputs: let
    username = "ratakor";
    theme = "gruvbox-dark"; # gruvbox-dark gruvbox-light dracula
  in {
    # Systems for which attributes of perSystem will be built. As
    # a rule of thumb, only systems provided by available hosts
    # should go in this list. More systems will increase evaluation
    # duration.
    # TODO: though I don't think it works as intended rn
    # systems = import inputs.systems;

    nixosConfigurations = {
      X200 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs;
          inherit username;
          colors = ((import ./modules/colors.nix) {pkgs = nixpkgs;})."${theme}";
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
              users.${username} = import ./home/${username};
            };
          }

          agenix.nixosModules.default
        ];
      };
    };
  };
}
