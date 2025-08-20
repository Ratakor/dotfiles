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
        inputs',
        self',
        ...
      }:
        lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            colors = (import ../modules/colors).${theme};
            muhlib = import ../lib {pkgs = inputs.nixpkgs;};
          };

          modules =
            [
              ./${hostname}
              (import ../overlays)
            ]
            ++ args.modules;
        }
    );
in {
  flake.nixosConfigurations = let
    # Flake inputs modules
    agenix = inputs.agenix.nixosModules.default;
    home-manager = inputs.home-manager.nixosModules.home-manager;

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
