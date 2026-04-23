{
  systems ? [ builtins.currentSystem or "x86_64-linux" ],
  sources ? import ./npins,
  lib ? import "${sources.nixpkgs}/lib",
  ...
}@args:
let
  sourceInfo =
    let
      info = builtins.fetchGit ./.;
    in
    if info.rev == "0000000000000000000000000000000000000000" then
      removeAttrs info [
        "rev"
        "shortRev"
      ]
    else
      info;

  self = args.self or (sourceInfo // outputs);

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
