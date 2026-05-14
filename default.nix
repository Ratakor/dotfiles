{
  systems ? [ builtins.currentSystem or "x86_64-linux" ],
  sources ? import ./npins,
  lib ? import ./parts/lib sources,
  ...
}@args:
let
  self = args.self or ({ outPath = ./.; } // outputs);

  parts = import ./parts {
    inherit
      lib
      self
      sources
      systems
      ;
  };

  hosts = import ./hosts {
    inherit lib self sources;
    inherit (parts) legacyPackages;
  };

  outputs = parts // {
    nixosConfigurations = hosts;
  };
in
outputs
