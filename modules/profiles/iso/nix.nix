{ config, lib, ... }:
let
  inherit (lib.strings) getName;
in
{
  # Tell the Nix evaluator to garbage collect more aggressively.
  # This is desirable in memory-constrained environments that don't
  # (yet) have swap set up.
  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

  nix.settings = {
    trusted-users = [ "@wheel" ];

    experimental-features = [
      "nix-command"
      "flakes"
      (if (getName config.nix.package) == "lix" then "pipe-operator" else "pipe-operators")
    ];

    log-lines = 50;
    http-connections = 50;
    connect-timeout = 5;

    warn-dirty = false;
    auto-optimise-store = false;
    accept-flake-config = false;

    substituters = [
      "https://cache.nixos.org/"
      "https://ratakor.cachix.org"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
}
