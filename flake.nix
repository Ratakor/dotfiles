{
  description = "Ratakor's basic NixOS configuration";

  # Nix configuration to use for this flake.
  # This doesn't affect the system configuration.
  nixConfig = {
    extra-substituters = [ "https://ratakor.cachix.org" ];
    extra-trusted-public-keys = [ "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0=" ];
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  outputs = inputs: import ./. inputs;
}
