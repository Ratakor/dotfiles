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
    modules,
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
            inherit inputs inputs' self self';
            colors = (import ../modules/colors).${theme};
          } {self.pkgs = self'.packages;};

          modules = [./${hostname}] ++ args.modules;
        }
    );
in {
  flake.nixosConfigurations = let
    # Flake inputs modules
    agenix = inputs.agenix.nixosModules.default;
    inherit (inputs.home-manager.nixosModules) home-manager;

    users = ../users;
    home = [home-manager users];

    shared = [agenix];
  in {
    X200 = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "X200";
      theme = "gruvbox-dark";
      modules = flatten [
        home
        shared
      ];
    };
  };
}
