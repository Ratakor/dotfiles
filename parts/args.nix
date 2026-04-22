{
  lib,
  self,
  sources,
  ...
}:
let
  # My SSH keys, exposed here to the flake & to flake-parts modules.
  keys = import ./keys.nix;

  # Wrappers library, exposed here to flake-parts modules.
  wlib = import "${sources.nix-wrapper-modules}/lib" { inherit lib; };
in
{
  perSystem =
    {
      config,
      system,
      ...
    }:
    {
      # from NotAShelf/nyx/parts/args.nix
      # Configure nixpkgs locally and expose it as <flakeRef>.legacyPackages.
      # This will then be consumed to override flake-parts' pkgs argument
      # to make sure pkgs instances in flake-parts modules are all referring
      # to the same configuration instance - this one.
      # This is especially useful if a custom package reference another custom
      # package. For example: custom package X depends on package Y, but Y is
      # outdated in nixpkgs. So we add an up-to-date custom package Y, and then X
      # can refer to it using this package instance.
      # Note that this isn't the same pkgs instance that is passed to other parts
      # of the flake like hosts/ or users/, it's only for flake-parts modules.
      legacyPackages = import sources.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
        overlays = [ self.overlays.default ];
      };

      # Override flake-parts' perSystem args
      _module.args = {
        inherit keys wlib;

        # https://github.com/hercules-ci/flake-parts/issues/106#issuecomment-1399041045
        pkgs = config.legacyPackages;
      };
    };

  # Expose useful stuff to the flake outputs.
  # That also means that they can be referenced using `self`.
  flake = {
    inherit keys sources;
  };
}
