{
  lib,
  self,
  sources,
  legacyPackages,
}:
let
  inherit (builtins) concatLists concatMap;
  inherit (lib.modules) mkDefault;
  inherit (lib.filesystem) filterNixFiles listModuleFiles listFilesRecursive;

  # External Modules
  disko = import "${sources.disko}/module.nix";
  inherit (sources) nixos-hardware;

  # Root path for local modules
  modulesPath = ../modules;

  # Local modules
  nixos = modulesPath + /nixos;
  options = modulesPath + /options;
  home = modulesPath + /home;

  # Profiles
  profiles = modulesPath + /profiles;
  workstation = profiles + /workstation;
  laptop = profiles + /laptop;
  server = profiles + /server;

  mkModules =
    {
      hostname,
      system,
      extraModules ? [ ],
    }:
    concatLists [
      [
        {
          networking.hostName = hostname;
          nixpkgs = {
            hostPlatform = mkDefault system;
            flake.source = sources.nixpkgs.outPath;
          };
        }
      ]
      (filterNixFiles (listFilesRecursive ./${hostname}))
      (concatMap listModuleFiles extraModules)
    ];

  # pkgs.nixos doesn't allow to pass specialArgs :(
  # Even if we set _module.args it will be evaluated too late and produce an infinite recursion.
  # https://github.com/NixOS/nixpkgs/blob/b12141ef619e0a9c1c84dc8c684040326f27cdcc/pkgs/top-level/all-packages.nix#L11967
  mkSystem =
    system: args:
    import "${sources.nixpkgs}/nixos/lib/eval-config.nix" (
      {
        inherit lib;
        pkgs = legacyPackages.${system};
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
    mkSystem system {
      modules = mkModules {
        inherit hostname system;
        extraModules = concatLists [
          extraModules
          profiles
          [
            nixos
            options
            home
          ]
        ];
      };
      specialArgs = {
        inherit self sources;
        inherit (self) keys;
      };
    };
in
{
  X200 = mkNixosSystem {
    hostname = "X200";
    profiles = [
      workstation
      laptop
    ];
  };

  AuroraR7 = mkNixosSystem {
    hostname = "AuroraR7";
    profiles = [
      workstation
    ];
  };
}
