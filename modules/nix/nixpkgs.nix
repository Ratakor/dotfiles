{
  config,
  lib,
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
      allowAliases = true; # TODO: set to false when we are ready to remove aliases
    };

    # This is the only allowed overlay, see vega for custom packages.
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

      # I could use the default overlay from vega and have all packages
      # available through `pkgs` but that's not consistent with how we access
      # the library (`vega.lib`) and I like to have a specific namespace for
      # non-nixpkgs packages.
      # inputs.vega.overlays.default
    ];
  };
}
