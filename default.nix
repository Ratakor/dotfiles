{
  systems ? [ builtins.currentSystem or "x86_64-linux" ],
  sources ? import ./npins,
  lib ? import ./parts/lib sources,
  ...
}@args:
let
  self = args.self or ({ outPath = ./.; } // outputs);

  outputs =
    lib.mkFlake
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
