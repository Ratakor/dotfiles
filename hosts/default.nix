{
  lib,
  self,
  sources,
  withSystem,
  ...
}:
let
  inherit (builtins) concatLists concatMap pathExists;

  # External Modules
  disko = import "${sources.disko}/module.nix";

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
            hostPlatform = lib.mkDefault system;
            flake.source = sources.nixpkgs.outPath;
          };
        }
      ]
      (lib.listNixFiles ./${hostname})
      (concatMap (
        path:
        let
          root = path + /default.nix;
        in
        if pathExists root then lib.singleton root else lib.listNixFiles path
      ) extraModules)
    ];

  # pkgs.nixos doesn't allow to pass specialArgs :(
  # Even if we set _module.args it will be evalutaed too late and produce an infinite recursion.
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
          inherit hostname system;
          extraModules = concatLists [
            extraModules
            profiles
            [
              nixos
              options
            ]
          ];
        };
        specialArgs = {
          inherit self sources;
          inherit (self) keys;
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
