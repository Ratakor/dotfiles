{
  systems ? [ builtins.currentSystem or "x86_64-linux" ],
  sources ? import ./npins,
  lib ? import "${sources.nixpkgs}/lib",
  ...
}@args:
let
  self = args.self or ({ outPath = ./.; } // outputs);

  outputs =
    (import "${sources.flake-parts}/lib.nix" { inherit lib; }).mkFlake
      {
        inputs = { inherit self; };
        specialArgs = { inherit sources; };
      }
      {
        inherit systems;
        imports = [
          ./parts
          ./hosts
        ];
      };
in
if args ? self then outputs else self
