{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.trivial) const;

  systemNix = config.nix.package;
in {
  nixpkgs.overlays = [
    # from notashelf/nyx
    # Some packages provide their own instances of Nix by adding `nix` to the argset
    # of a derivation. While in most cases a simple `.override` will allow you to easily
    # replace their instance of Nix, you might want to do it across the dependency tree
    # in certain cases. For example if the package you are overriding is a dependency to
    # or is called by other packages.
    (const (prev: {
      nixos-rebuild = prev.nixos-rebuild.override {
        nix = systemNix;
      };

      nix-direnv = prev.nix-direnv.override {
        nix = systemNix;
      };

      nix-index = prev.nix-index.override {
        nix = systemNix;
      };
    }))

    (const (super: {
      luciole-fonts = super.callPackage ./luciole-fonts.nix {};
    }))

    # needed in overlay because tofi is used in a lot of my scripts
    (const (super: {
      tofi-dmenu = super.tofi.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [./patches/tofi-dmenu-20240910.diff];
      });
    }))
  ];
}
