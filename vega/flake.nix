# Based on https://github.com/notashelf/nyxexprs and https://github.com/diniamo/niqspkgs
# TODO: setup cachix: see https://github.com/diniamo/niqspkgs/blob/main/.github/workflows/cachix.yaml
{
  description = "Nixpkgs lib & packages extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";

    # Flake packages

    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flint = {
      url = "github:NotAShelf/flint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs self;} {
      flake = {
        lib = import ./lib {inherit (nixpkgs) lib;};
      };

      systems = import inputs.systems;

      imports = [flake-parts.flakeModules.easyOverlay];

      perSystem = {
        system,
        inputs',
        config,
        pkgs,
        lib,
        ...
      }: let
        inherit (builtins) concatStringsSep match listToAttrs;
        inherit (lib.attrsets) recursiveUpdate;
        inherit (lib.filesystem) packagesFromDirectoryRecursive;
        inherit (lib.customisation) callPackageWith;

        pins = import ./npins;
        date = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" self.lastModifiedDate);
      in {
        # _module.args.pkgs = import nixpkgs {
        #   inherit system;
        #   config.allowUnfree = true;
        # };

        # Add all packages to the default overlay which can be consumed as follows:
        # `nixpkgs.overlays = [inputs.vega.overlays.default];`
        overlayAttrs = config.packages;

        packages = let
          extraArgs = {inherit pins date;};

          base = packagesFromDirectoryRecursive {
            callPackage = callPackageWith (recursiveUpdate pkgs extraArgs);
            directory = ./pkgs;
          };

          fromInputs = [
            "watt"
            "flint"
          ];

          mappedPkgs = listToAttrs (map (input: {
              name = input;
              value = inputs'.${input}.packages.default or (throw "Input '${input}' does not provide default package");
            })
            fromInputs);
        in
          base // mappedPkgs;

        # We use the monorepo's formatter instead of setting up our own.
        # formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShellNoCC {
          name = "vega";
          packages = [pkgs.npins];
        };
      };
    };
}
