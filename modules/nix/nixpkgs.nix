{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib.trivial) const;

  systemNix = config.nix.package;
in {
  nixpkgs = {
    # Global nixpkgs configuration.
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
      allowUnfree = true;

      # Whether to allow unsupported systems.
      # See https://nixos.org/manual/nixpkgs/stable/#sec-allow-unsupported-system.
      # This is useful for cross-compilation.
      # Default: false || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"
      allowUnsupportedSystem = true;

      # Whether to warn when config contains an unrecognized attribute.
      # Default: false
      warnUndeclaredOptions = true;

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

    # This is the only allowed overlay, see self.pkgs for custom packages.
    overlays = [
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

      # Same as `lib`, I could merge nixpkgs and this flake packages by using
      # the exposed overlay but I prefer to have a separate namespace.
      # self.pkgs is an alias for self'.packages provided by flake-parts.
      # inputs.self.overlays.default

      # https://github.com/NixOS/nixpkgs/pull/433847
      (const (prev: {
        pmount = self.pkgs.pmount;
      }))
    ];
  };
}
