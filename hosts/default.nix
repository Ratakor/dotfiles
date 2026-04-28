{
  lib,
  self,
  sources,
  withSystem,
  ...
}:
let
  inherit (builtins) filter concatLists;
  inherit (lib.modules) mkDefault;
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

  # Recursively find all `.nix` files in a given path
  listNixFiles = path: filter (hasSuffix ".nix") (listFilesRecursive path);

  mkModules =
    {
      hostname,
      system,
      moduleTrees ? [ ],
      extraModules ? [ ],
    }:
    flatten (concatLists [
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
      (map listNixFiles moduleTrees)
      extraModules
    ]);

  # TODO: use pkgs.nixos instead
  # I keep getting infinite recursion when setting _modules.args tho
  # https://github.com/NixOS/nixpkgs/blob/b12141ef619e0a9c1c84dc8c684040326f27cdcc/pkgs/top-level/all-packages.nix#L11967
  mkSystem =
    pkgs: args:
    import "${sources.nixpkgs}/nixos/lib/eval-config.nix" (
      {
        inherit lib pkgs;
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
      { pkgs, ... }:
      mkSystem pkgs {
        modules = mkModules {
          inherit
            hostname
            system
            # extraModules
            ;
          moduleTrees = profiles ++ [ nixos ];
          # TODO: we can't put options in moduleTrees because of colors
          extraModules = extraModules ++ (listFilesRecursive options |> filter (hasSuffix "module.nix"));
        };
        specialArgs = {
          inherit self sources;
        };
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
