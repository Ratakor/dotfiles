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
            inherit inputs inputs' self self';
            colors = (import ../modules/options/colors).${theme};
          } {self.pkgs = self'.packages;};

          modules = [./${hostname}] ++ (args.modules or []);
        }
    );
in {
  flake.nixosConfigurations = let
    # Flake inputs modules
    agenix = inputs.agenix.nixosModules.default;

    # Local modules, based on notashelf/nyx/hosts, need more docs + incomplete
    modulePath = ../modules;

    coreModules = modulePath + /core;
    # extraModules = modulePath + /extra;
    # options = modulePath + /options;

    users = ../users;
    home = [users];

    shared = [agenix coreModules];
  in {
    X200 = mkNixosSystem {
      hostname = "X200";
      system = "x86_64-linux";
      theme = "gruvbox-dark";
      modules = flatten [
        home
        shared
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
}
