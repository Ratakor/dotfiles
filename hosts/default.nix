{
  self,
  inputs,
  withSystem,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) flatten;

  mkNixosSystem = {
    system,
    hostname,
    theme ? "gruvbox-dark", # gruvbox-dark gruvbox-light dracula
    ...
  } @ args:
    withSystem system (
      {
        self',
        inputs',
        ...
      }:
        lib.nixosSystem {
          specialArgs = recursiveUpdate {
            inherit (self) keys;
            inherit inputs inputs' self self';
            colors = (import ../modules/colors).${theme};
          } {self.pkgs = self'.packages;};

          modules = [./${hostname}] ++ (args.modules or []);
        }
    );

  # merge this with mkNixosSystem?
  mkHomeConfig = {
    system,
    modules,
    theme ? "gruvbox-dark", # gruvbox-dark gruvbox-light dracula
    ...
  } @ args:
    withSystem system (
      {
        self',
        inputs',
        pkgs,
        ...
      }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit modules pkgs;
          extraSpecialArgs = recursiveUpdate {
            inherit (self) keys;
            inherit inputs inputs' self self';
            colors = (import ../modules/colors).${theme};
          } {self.pkgs = self'.packages;};
        }
    );
in {
  flake.nixosConfigurations = let
    # Flake inputs modules
    agenix = inputs.agenix.nixosModules.default;
    inherit (inputs.home-manager.nixosModules) home-manager;

    users = ../users;
    home = [home-manager users];

    # TODO
    all = [../modules];

    shared = [agenix];
  in {
    X200 = mkNixosSystem {
      hostname = "X200";
      system = "x86_64-linux";
      theme = "gruvbox-dark";
      modules = flatten [
        home
        shared
        all
      ];
    };
    # AuroraR7 = mkNixosSystem {
    #   hostname = "AuroraR7";
    #   system = "x86_64-linux";
    #   theme = "gruvbox-dark";
    #   modules = flatten [
    #     home
    #     shared
    #   ];
    # };
  };

  # apparently this is needed
  # https://flake.parts/options/home-manager.html
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  # TODO: requires homeModules configuration
  # could regular flake parts modules be used instead?
  # https://flake.parts/options/flake-parts-modules.html
  flake.homeConfigurations = {
    "ratakor@AuroraR7" = mkHomeConfig {
      system = "x86_64-linux";
      theme = "gruvbox-dark";
      modules = [
        {
          home = {
            username = "ratakor";
            homeDirectory = "/home/ratakor";
            stateVersion = "25.05";
          };
        }
        # (import ../users)
      ];
    };
  };
}
