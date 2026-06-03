{
  lib,
  self,
  sources,
  legacyPackages,
}:
let
  inherit (builtins) concatLists concatMap mapAttrs;
  inherit (lib.modules) mkDefault;
  inherit (lib.filesystem)
    filterNixFiles
    listModuleFiles
    listFiles
    listFilesRecursive
    ;
  inherit (lib.attrsets) genAttrs';

  # External Modules
  disko = sources.disko + /module.nix;
  inherit (sources) nixos-hardware;

  # Root path for local modules
  modulesPath = ../modules;

  # Local modules
  nixos = modulesPath + /nixos;
  options = modulesPath + /options;
  profiles = genAttrs' (listFiles (modulesPath + /profiles)) (path: {
    name = baseNameOf path;
    value = path;
  });

  mkNixosSystem =
    name:
    {
      hostname ? name,
      system ? "x86_64-linux",
      moduleTrees ? [
        nixos
        options
      ],
      profiles ? [ ],
      extraModules ? [ ],
    }:
    # pkgs.nixos doesn't allow to pass specialArgs :(
    # Even if we set _module.args it will be evaluated too late and produce an infinite recursion.
    # https://github.com/NixOS/nixpkgs/blob/b12141ef619e0a9c1c84dc8c684040326f27cdcc/pkgs/top-level/all-packages.nix#L11967
    import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
      inherit lib;
      pkgs = legacyPackages.${system};
      system = null; # We set config.nixpkgs.hostPlatform instead.
      modules = concatLists [
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
        (concatMap listModuleFiles (moduleTrees ++ profiles))
        extraModules
      ];
      specialArgs = {
        inherit self sources;
        inherit (self) keys;
      };
    };
in
mapAttrs mkNixosSystem {
  X200 = {
    profiles = with profiles; [
      workstation
      laptop
    ];
  };

  AuroraR7 = {
    profiles = with profiles; [
      workstation
    ];
  };

  nomTemporaire = {
    profiles = with profiles; [
      workstation
      laptop
    ];
    extraModules = [
      "${nixos-hardware}/framework/13-inch/amd-ai-300-series"
    ];
  };
}
