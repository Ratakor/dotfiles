{
  self,
  inputs,
  withSystem,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (builtins) filter concatLists;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) flatten singleton;
  inherit (lib.strings) hasSuffix;

  # Root path for local modules
  modulePath = ../modules;

  nixos = modulePath + /nixos;
  options = modulePath + /options;
  profiles = modulePath + /profiles;

  # Profiles
  graphical = profiles + /graphical;
  workstation = profiles + /workstation;
  laptop = profiles + /laptop;
  # server = profiles + /server;

  wrapModule = modulePath + /wrap;
  wrapHome = modulePath + /home;
  home-v2 = [wrapModule wrapHome];

  inherit (inputs.home-manager.nixosModules) home-manager;
  users = ../users; # home-manager user configurations
  home = [home-manager users];

  # Recursively find all `module.nix` files in a given path
  mkModuleTree = path:
    filter (hasSuffix "module.nix") (
      map toString (listFilesRecursive path)
    );

  mkModulesFor = hostname: {
    moduleTrees ? [nixos options],
    profiles ? [],
    extraModules ? [],
  }:
    flatten (
      concatLists [
        # Host-specific configuration
        (singleton ./${hostname})

        # Recursively import all module trees (i.e. directories with a `module.nix`)
        # for given moduleTree directories, and in addition, profiles.
        (map (path: mkModuleTree path) (concatLists [moduleTrees profiles]))

        extraModules
      ]
    );

  mkNixosSystem = {
    system ? "x86_64-linux",
    modules,
  }:
    withSystem system (
      {
        self',
        inputs',
        ...
      }:
        lib.nixosSystem {
          inherit modules;
          specialArgs =
            recursiveUpdate
            {inherit inputs inputs' self self';}
            {self.pkgs = self'.packages;};
        }
    );
in {
  flake.nixosConfigurations = {
    X200 = mkNixosSystem {
      modules = mkModulesFor "X200" {
        profiles = [graphical workstation laptop];
        extraModules = [home home-v2];
      };
    };
    # AuroraR7 = mkNixosSystem {
    #   modules = mkModulesFor "AuroraR7" {
    #     profiles = [graphical workstation];
    #     extraModules = [home];
    #   };
    # };
  };
}
