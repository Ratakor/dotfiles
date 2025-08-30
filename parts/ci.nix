{
  # Omnix CI configuration
  # https://omnix.page/om/ci#custom
  flake.om.ci.default.root = {
    dir = ".";
    steps = {
      # Check that `flake.lock` is up to date
      lockfile.enable = false;
      # Build all flake outputs using devour-flake
      build.enable = true;
      # Run `nix flake check` (handled by another CI)
      flake-check.enable = false;
    };
  };
}
