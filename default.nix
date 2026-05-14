{
  sources ? import ./npins,
  system ? builtins.currentSystem or "x86_64-linux",
  ...
}@args:
let
  self = args.self or ({ outPath = ./.; } // outputs);

  flake = import ./flake {
    inherit self sources;
    systems = [ system ];
  };

  hosts = import ./hosts {
    inherit self sources;
    inherit (flake) legacyPackages lib;
  };

  outputs = flake // {
    nixosConfigurations = hosts;
  };
in
outputs
