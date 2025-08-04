# see https://github.com/Misterio77/nix-starter-configs/tree/main/standard for a simple starter
# based on https://github.com/ryan4yin/nix-config/tree/i3-kickstarter
# and https://github.com/ryan4yin/nix-config/tree/42bcfeb47c31b27d1a80b46ddbb29b76c1299d3a

{
  description = "NixOS configuration";

  # the nixConfig here only affects the flake itself, not the system configuration
  # nixConfig = {
  #   # extra-substituers will be appended to the default substituters when fetching packages
  #   extra-substituters = [
  #     "https://nix-community.cachix.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #   ];
  # };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: this feels very wrong (4 diff nixpkgs already)
    # custom packages
    zig-2048.url = "github:ratakor/2048.zig";
    zpotify.url = "github:ratakor/zpotify";

    wallpapers = {
      url = "github:ratakor/wallpapers";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  }: let
    username = "ratakor";
    theme = "gruvbox-dark"; # gruvbox-dark gruvbox-light dracula
  in {
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
          colors = ((import ./modules/colors.nix) { pkgs = nixpkgs; })."${theme}";
        };

        modules = [
          ./hosts/X200

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.backupFileExtension = "hm.bak";
            home-manager.users.${username} = import ./home/${username};
          }
        ];
      };
    };
  };
}
