{
  systems ? [ "x86_64-linux" ],
  sources ? import ./npins,
  lib ? import "${sources.nixpkgs}/lib",
  ...
}@args:
let
  outputs =
    (import "${sources.flake-parts}/lib.nix" { inherit lib; }).mkFlake
      {
        inputs = {
          self = args.self or outputs; # TODO: self is more than outputs
        };
        specialArgs = {
          inherit sources;
        };
      }
      {
        inherit systems;
        imports = [
          ./parts
          ./hosts
        ];
      };
in
outputs
