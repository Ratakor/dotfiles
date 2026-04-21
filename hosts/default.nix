{
  inputs,
  lib,
  self,
  sources,
  withSystem,
  ...
}:
let
  inherit (builtins) filter concatLists;
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) flatten;
  inherit (lib.strings) hasSuffix;

  # External Modules
  disko = import "${sources.disko}/module.nix";

  # Root path for local modules
  modulePath = ../modules;

  # Local modules
  nixos = modulePath + /nixos;
  options = modulePath + /options;
  profiles = modulePath + /profiles;
  home = modulePath + /home;

  # Profiles
  workstation = profiles + /workstation;
  laptop = profiles + /laptop;
  server = profiles + /server;

  # Recursively find all `module.nix` files in a given path
  mkModuleTree = path: filter (hasSuffix "module.nix") (map toString (listFilesRecursive path));

  mkModules =
    {
      hostname,
      system,
      moduleTrees ? [ ],
      profiles ? [ ],
      extraModules ? [ ],
    }:
    flatten (concatLists [
      # Host-specific configuration
      [
        ./${hostname}
        {
          networking.hostName = hostname;
          nixpkgs = {
            hostPlatform = mkDefault system;
            flake.source = sources.nixpkgs.outPath;
          };
        }
      ]

      # Recursively import all module trees (i.e. directories with a `module.nix`)
      # for given moduleTree directories, and in addition, profiles.
      (map (path: mkModuleTree path) (concatLists [
        moduleTrees
        profiles
      ]))

      extraModules
    ]);

  mkSystem =
    args:
    import "${sources.nixpkgs}/nixos/lib/eval-config.nix" (
      {
        inherit lib;
        system = null; # set config.nixpkgs.hostPlatform instead.
      }
      // args
    );

  mkNixosSystem =
    {
      hostname,
      system ? "x86_64-linux",
      profiles ? [ ],
      extraModules ? [ ],
    }:
    withSystem system (
      {
        self',
        inputs',
        wlib,
        ...
      }:
      mkSystem {
        modules = mkModules {
          inherit
            hostname
            system
            profiles
            extraModules
            ;
          moduleTrees = [
            nixos
            options
          ];
        };
        specialArgs = recursiveUpdate {
          inherit
            inputs
            inputs'
            self
            self'
            wlib
            ;
        } { self.pkgs = self'.packages; };
      }
    );
in
{
  flake.nixosConfigurations = {
    X200 = mkNixosSystem {
      hostname = "X200";
      profiles = [
        workstation
        laptop
      ];
      extraModules = [ home ];
    };
    AuroraR7 = mkNixosSystem {
      hostname = "AuroraR7";
      profiles = [
        workstation
      ];
      extraModules = [ home ];
    };
  };
}
