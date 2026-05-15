# sed 's/template/project_name/g' *
# edit dune-project
# nix run nixpkgs#dune_3 -- build
# nix flake lock
{
  description = "OCaml Template";

  inputs = {
    # nixpkgs.follows = "opam-nix/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    opam-nix = {
      url = "github:tweag/opam-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      opam-nix,
      treefmt-nix,
      ...
    }:
    let
      package = "template";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        fs = lib.fileset;
        src = fs.toSource {
          root = ./.;
          fileset = fs.unions [
            ./bin
            ./lib
            # ./test
            ./${package}.opam
            ./dune-project
          ];
        };
        devPackagesQuery = {
          # You can add "development" packages here.
          # They will get added to the devShell automatically.
          # ocaml-lsp-server = "*";
          # ocamlformat = "0.28.1";
        };
        query = devPackagesQuery // {
          ## You can force versions of certain packages here, e.g:
          ## - force the ocaml compiler to be taken from opam-repository:
          # ocaml-base-compiler = "*";
          ## - or force the compiler to be taken from nixpkgs and be a certain version:
          ocaml-system = "*";
          ## - or force ocamlfind to be a certain version:
          # ocamlfind = "1.9.2";
        };
        scope = opam-nix.lib.${system}.buildOpamProject' { } src query;
        overlay = _final: prev: {
          # You can add overrides here
          ${package} = prev.${package}.overrideAttrs (_: {
            # Prevent the ocaml dependencies from leaking into dependent environments
            doNixSupport = false;
          });
        };
        scope' = scope.overrideScope overlay;
        # The main package containing the executable
        main = scope'.${package};
        # Packages from devPackagesQuery
        devPackages = builtins.attrValues (lib.getAttrs (builtins.attrNames devPackagesQuery) scope');

        treefmt = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            ocamlformat.enable = true;
          };
        };
      in
      {
        # legacyPackages = scope';

        packages.default = main;

        devShells.default = pkgs.mkShellNoCC {
          inputsFrom = [ main ];
          buildInputs =
            devPackages
            ++ (with pkgs.ocamlPackages; [
              ocamlformat
              ocaml-lsp
            ]);
        };

        formatter = treefmt.config.build.wrapper;

        checks = {
          formatting = treefmt.config.build.check self;
          # TODO: dune test
        };
      }
    );
}
