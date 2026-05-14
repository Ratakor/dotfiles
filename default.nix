{
  systems ? [ builtins.currentSystem or "x86_64-linux" ],
  sources ? import ./npins,
  lib ? import ./flake/lib sources,
  ...
}@args:
let
  self = args.self or ({ outPath = ./.; } // outputs);

  flake = import ./flake {
    inherit
      lib
      self
      sources
      systems
      ;
  };

  hosts = import ./hosts {
    inherit lib self sources;
    inherit (flake) legacyPackages;
  };

  outputs = flake // {
    nixosConfigurations = hosts;
  };
in
outputs
