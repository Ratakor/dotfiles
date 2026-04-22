{
  description = "Ratakor's basic NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://ratakor.cachix.org" ];
    extra-trusted-public-keys = [ "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0=" ];
    extra-experimental-features = [ "pipe-operators" ];
  };

  outputs = inputs: import ./. inputs;
}
