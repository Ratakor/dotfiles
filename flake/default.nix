{
  lib,
  self,
  sources,
  systems,
}@args:
let
  pkgs = import ./pkgs args;
  apps = import ./apps;
  fmt = import ./fmt.nix { inherit self sources; };
  # preCommit = import ./pre-commit.nix { inherit lib self sources; };

  eachSystem = f: lib.genAttrs systems (system: f pkgs.legacyPackages.${system});
in
{
  # Overlays exposed by the flake.
  inherit (pkgs) overlays;

  # Packages exposed to the flake via `packages.${system}.${pkgName}`.
  # packages = withSystem (system: (pkgs.perSystem system).packages);
  inherit (pkgs) packages;

  # Pinned nixpkgs packages, custom packages and wrappers exposed to the
  # flake and used by the whole flake.
  # Wrappers can be accessed via `leglegacyPackages.${system}.wrappers.${pkgName}`.
  inherit (pkgs) legacyPackages;

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
