{
  config,
  lib,
  ...
}: let
  inherit (lib.trivial) const;

  systemNix = config.nix.package;
in {
  nixpkgs.overlays = [
    # custom packages not available in nixpkgs
    (const (super: import ../pkgs {pkgs = super;}))

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

    # add compatibility patches to tofi
    (const (super: {
      tofi-dmenu = super.tofi.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [./patches/tofi-dmenu-20240910.diff];
      });
    }))

    # remove when https://github.com/NixOS/nixpkgs/pull/433847 gets merged
    (const (super: {
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/pm/pmount/package.nix
      pmount = super.pmount.overrideAttrs (oldAttrs: {
        configureFlags =
          (oldAttrs.configureFlags or [])
          ++ [
            "--with-cryptsetup-prog=${super.cryptsetup}/bin/cryptsetup"
          ];
        # nixpkgs patches are too old
        patches = let
          # https://salsa.debian.org/debian/pmount/-/tree/debian/master/debian/patches
          # https://salsa.debian.org/debian/pmount/-/tree/430e4634aa7a2e6a5a91852c5b0fd3698b186000/debian/patches
          fetchDebPatch = {
            name,
            hash,
          }:
            super.fetchpatch {
              inherit name hash;
              url = "https://salsa.debian.org/debian/pmount/-/raw/430e4634aa7a2e6a5a91852c5b0fd3698b186000/debian/patches/${name}";
            };
        in
          map fetchDebPatch [
            {
              name = "02-fix-spelling-binary-errors.patch";
              hash = "sha256-ukGHDqsG3Eo/0bhv2GPwX0N6uZOI+3BowMY+l1wtd9o=";
            }
            {
              name = "03-fix-spelling-manpage-error.patch";
              hash = "sha256-rsa3t165+yWBOnRV3SnOMmYSuNuydZtnOdydUzcjDaQ=";
            }
            {
              name = "04-fix-implicit-function-declaration.patch";
              hash = "sha256-Le8gVIW72oZGymN7gM5uOGNEhrzOTirnilNedUkSpco=";
            }
            {
              name = "05-exfat-support.patch";
              hash = "sha256-Yl9QuA8tMIej4nQIbYibcUVFJdgnVaN+34/xoJp5NbU=";
            }
            {
              name = "06-C99-implicit-function-declaration-fixes.patch";
              hash = "sha256-xFFfl9BkBqbUSAKaJwvKNgHyWbxUO5wKyEpwz3anwdM=";
            }
            {
              name = "07-Add-probing-for-Btrfs.patch";
              hash = "sha256-9SKyLAVmZTGgsAi9aCxkw1OzWVcegoZy2DaupiS9kPA=";
            }
            {
              name = "08-Support-btlkOpen-alongside-of-luksOpen.patch";
              hash = "sha256-2PJky3lRUKkOB2Js86XN8gqmYMxpsUbLJ39XnrirCDw=";
            }
            {
              name = "09-Probe-for-f2fs.patch";
              hash = "sha256-VMnrSEaIPwEfbUi+Q88vQdSBQgq4+jJ19Bjc/ueemnw=";
            }
          ];
      });
    }))
  ];
}
