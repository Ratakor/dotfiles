{
  description = "Zig Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    zig = {
      url = "github:silversquirl/zig-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      # https://github.com/zigtools/zls/pull/2469
      url = "github:Ratakor/zls/older-versions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig-flake.follows = "zig";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    zig,
    zls,
    ...
  }: let
    forAllSystems = f: builtins.mapAttrs f nixpkgs.legacyPackages;
  in {
    devShells = forAllSystems (system: pkgs: {
      default = pkgs.mkShellNoCC {
        inherit (self.packages.${system}.default) nativeBuildInputs buildInputs;

        packages = with pkgs; [
          git
          bash
          zig.packages.${system}.zig_0_15_1
          zls.packages.${system}.zls_0_15_0

          # `zig build release` dependencies
          gnutar
          xz
          p7zip
        ];
      };
    });

    packages = forAllSystems (system: pkgs: {
      default = zig.packages.${system}.zig_0_15_1.makePackage {
        pname = "zig-template";
        version = "0.1.0-dev";

        src = ./.;
        zigReleaseMode = "fast";
        # depsHash = "<replace this with the hash Nix provides in its error message>"

        nativeBuildInputs = with pkgs; [];

        buildInputs = with pkgs; [];
      };
    });
  };
}
