{
  lib,
  self,
  sources,
  systems,
}:
let
  pkgs = import ./pkgs { inherit lib self sources; };
  apps = import ./apps;
  fmt = import ./fmt.nix { inherit self sources; };
  # preCommit = import ./pre-commit.nix { inherit lib self sources; };

  withSystem = lib.genAttrs systems;
  eachSystem = f: withSystem (system: f (pkgs.perSystem system).legacyPackages);
in
{
  # Overlays exposed by the flake.
  overlays = pkgs.overlays;

  # Packages exposed to the flake via `packages.${system}.${pkgName}`.
  packages = withSystem (system: (pkgs.perSystem system).packages);

  # Pinned nixpkgs packages, custom packages and wrappers exposed to the
  # flake and used by the whole flake.
  # Wrappers can be accessed via `leglegacyPackages.${system}.wrappers.${pkgName}`.
  legacyPackages = eachSystem lib.id;

  # Apps usable with `nix run`.
  apps = eachSystem apps;

  # Formatter for `nix fmt`.
  formatter = eachSystem (pkgs: (fmt pkgs).formatter);

  # Checks for `nix flake check`
  checks = eachSystem (pkgs: {
    treefmt = (fmt pkgs).check;
    # pre-commit = preCommit pkgs;
  });

  # Templates for `nix flake init -t FLAKE#TEMPLATE`.
  templates = import ./templates;

  # Expose useful stuff to the flake outputs.
  # That also means that they can be referenced using `self`.
  inherit lib sources;
  keys = import ./keys.nix;
}
