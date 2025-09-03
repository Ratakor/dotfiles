{
  config,
  self,
  inputs,
  withSystem,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (builtins) filter;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) flatten concatLists singleton;
  inherit (lib.strings) hasSuffix;

  # Root path for local modules
  modulePath = ../modules;

  core = modulePath + /core;
  options = modulePath + /options;
  roles = modulePath + /roles;

  # Roles
  graphical = roles + /graphical; # Currently only provide an X server
  workstation = roles + /workstation;
  laptop = roles + /laptop;
  # server = roles + /server;

  inherit (inputs.home-manager.nixosModules) home-manager;
  users = ../users; # home-manager user configurations
  home = [home-manager users];

  # Recursively find all `module.nix` files in a given path
  mkModuleTree = path:
    filter (hasSuffix "module.nix") (
      map toString (listFilesRecursive path)
    );

  mkModulesFor = hostname: {
    moduleTrees ? [core options],
    roles ? [],
    extraModules ? [],
  }:
    flatten (
      concatLists [
        # Host-specific configuration
        (singleton ./${hostname})

        # Recursively import all module trees (i.e. directories with a `module.nix`)
        # for given moduleTree directories, and in addition, roles.
        (map (path: mkModuleTree path) (concatLists [moduleTrees roles]))

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
        roles = [graphical workstation laptop];
        extraModules = [home];
      };
    };
    # AuroraR7 = mkNixosSystem {
    #   modules = mkModulesFor "AuroraR7" {
    #     roles = [graphical workstation];
    #     extraModules = [home];
    #   };
    # };
  };
}
