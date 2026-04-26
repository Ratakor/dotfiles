{
  lib,
  self,
  sources,
  ...
}:
let
  inherit (builtins) elem substring concatStringsSep;
  inherit (lib.customisation) callPackageWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.strings) optionalString getName escapeShellArg;
  inherit (lib.lists) length zipListsWith;
  inherit (lib.trivial) const warnIfNot;

  wlib = import "${sources.nix-wrapper-modules}/lib" { inherit lib; };

  acknowledgedUnfreePackages = [
    "nvidia-x11"
    "ouch" # rar
    "discord"
    "spotify"
    "steam"
    "steam-unwrapped"
  ];
in
{
  imports = [ "${sources.flake-parts}/extras/easyOverlay.nix" ];

  perSystem =
    {
      system,
      config,
      pkgs,
      final, # pkgs + the default overlay
      ...
    }:
    let
      colors = import "${self}/modules/options/colors" { inherit lib pkgs; };

      extraArgs = { inherit colors sources wlib; };

      packages =
        let
          craneLib = pkgs.callPackage "${sources.crane}/lib" { };
          diskoVersion =
            let
              versionInfo = import "${sources.disko}/version.nix";
            in
            versionInfo.version + (optionalString (!versionInfo.released) "-dirty");

          base = packagesFromDirectoryRecursive {
            callPackage = callPackageWith (pkgs // extraArgs);
            directory = ./packages;
          };

          fromSources = {
            # age-encrypted secrets for NixOS
            agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { };
            # Declarative disk partitioning and formatting using nix
            disko = pkgs.callPackage "${sources.disko}/package.nix" { inherit diskoVersion; };
            disko-install = fromSources.disko.overrideAttrs (const {
              name = "disko-install";
            });
            # Stupid simple utility for linting your flake inputs
            flint = pkgs.callPackage "${sources.flint}/nix/package.nix" { };
            # A scrollable-tiling Wayland compositior. Git version. Peak usage of flake btw.
            niri-git = (self.lib.flakes.package sources.niri system { rust-overlay = { }; }).overrideAttrs {
              # well flake-compat isn't perfect but I love it
              version = substring 0 7 sources.niri.revision;
              __intentionallyOverridingVersion = true;
            };
            # Source of sources
            npins = pkgs.callPackage "${sources.npins}/npins.nix" { };
            # Wayland clipboard "manager"
            stash = pkgs.callPackage "${sources.stash}/nix/package.nix" { inherit craneLib; };
            # Automatic CPU speed & power optimizer for Linux
            watt = pkgs.callPackage "${sources.watt}/nix/package.nix" { };
            # CLI tool to restore files from ZFS snapshots
            zfs-restore = pkgs.callPackage "${sources.zfs-restore}/nix/package.nix" { };
            # CLI/TUI for Spotify
            zpotify = pkgs.callPackage "${sources.zpotify}/nix/package.nix" { };
            # Helix keybinds for Z Shell
            zsh-helix-mode = pkgs.callPackage "${sources.zsh-helix-mode}/default.nix" { };
          };
        in
        base // fromSources;

      wrappers = packagesFromDirectoryRecursive {
        callPackage = callPackageWith (final // extraArgs);
        directory = ./wrappers;
      };
    in
    {
      # Add all packages to the default overlay which can be consumed as follows:
      # `nixpkgs.overlays = [inputs.FLAKE_NAME.overlays.default];`
      overlayAttrs = packages // {
        inherit wrappers;
      };

      # Packages exposed to the flake via `packages.${system}.${pkgName}`.
      inherit packages;

      # Pinned nixpkgs packages, custom packages and wrappers exposed to the
      # flake and used by the whole flake.
      # Wrappers can be accessed via `legacylegacyPackages.${system}.wrappers.${pkgName}`.
      legacyPackages = import sources.nixpkgs {
        inherit system;

        # https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig
        # https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference
        config = {
          # Whether to allow broken packages.
          # See https://nixos.org/manual/nixpkgs/stable/#sec-allow-broken.
          # Default: false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1"
          allowBroken = false;

          # Whether to allow unfree packages.
          # See https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree.
          # Default: false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1"
          # allowUnfree = true;
          allowUnfreePredicate =
            pkg:
            let
              pkgName = getName pkg;
            in
            warnIfNot (elem pkgName acknowledgedUnfreePackages) "Allowing unfree package: ${pkgName}" true;

          # Whether to allow unsupported systems.
          # See https://nixos.org/manual/nixpkgs/stable/#sec-allow-unsupported-system.
          # This is useful for cross-compilation.
          # Default: false || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"
          allowUnsupportedSystem = true;

          # Whether to warn when config contains an unrecognized attribute.
          # This is so stupid it can't even recognise valid attributes.
          # Default: false
          warnUndeclaredOptions = false;

          # Whether to expose old attribute names for compatibility.
          #
          # The recommended setting is to enable this, as it improves backward
          # compatibility, easing updates.
          #
          # The only reason to disable aliases is for continuous integration
          # purposes. For instance, Nixpkgs should not depend on aliases in its
          # internal code. Projects that aren’t Nixpkgs should be cautious of
          # instantly removing all usages of aliases, as migrating too soon can
          # break compatibility with the stable Nixpkgs releases.
          #
          # Default: true
          allowAliases = false;
        };

        overlays = [
          # This is overall a bad idea to dogfood flake-parts' easy overlay
          # but it's fine dw. Do a proper overlay instead of better control.
          self.overlays.default

          # Replace _all_ instances of nix with latest lix.
          (final: prev: {
            inherit (prev.lixPackageSets.latest) lix;
            nix = final.lix;
          })

          # Replace nix-output-monitor ugly icons.
          (final: prev: {
            nix-output-monitor =
              let
                oldIcons = [
                  "↑"
                  "↓"
                  "⏱"
                  "⏵"
                  "✔"
                  "⏸"
                  "⚠"
                  "∅"
                  "∑"
                ];
                newIcons = [
                  "f062" # 
                  "f063" # 
                  "f520" # 
                  "f04b" # 
                  "f00c" # 
                  "f04c" # 
                  "f071" # 
                  "f1da" # 
                  "f04a0" # 󰒠
                ];
              in
              assert length oldIcons == length newIcons;
              prev.nix-output-monitor.overrideAttrs (prevAttrs: {
                postPatch = (prevAttrs.postPatch or "") + ''
                  sed -i ${
                    escapeShellArg (concatStringsSep "\n" (zipListsWith (a: b: "s/${a}/\\\\x${b}/") oldIcons newIcons))
                  } lib/NOM/Print.hs

                  substituteInPlace lib/NOM/Print/Tree.hs --replace-fail '┌' '╭'
                '';
              });
          })
        ];
      };

      # Override flake-parts' perSystem pkgs
      _module.args.pkgs = config.legacyPackages;
    };
}
