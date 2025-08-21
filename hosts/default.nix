{
  inputs,
  withSystem,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

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
          specialArgs = {
            inherit inputs inputs';
            colors = (import ../modules/colors).${theme};
            vega = {
              inherit (inputs.vega) lib;
              pkgs = inputs'.vega.packages;
            };
          };

          modules = [./${hostname}] ++ args.modules;
        }
    );
in {
  flake.nixosConfigurations = let
    # Flake inputs modules
    agenix = inputs.agenix.nixosModules.default;
    inherit (inputs.home-manager.nixosModules) home-manager;

    homeConfig = ../home;
    home = [home-manager homeConfig];

    shared = [agenix];
  in {
    X200 = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "X200";
      theme = "gruvbox-dark";
      modules = lib.lists.flatten [
        home
        shared
      ];
    };
  };
}
