sources:
(import "${sources.nixpkgs}/lib").extend (
  self: lib:
  let
    # callLib = name: (lib.${name} or { }) // (import ./${name}.nix { inherit lib sources self; });
    callLib = path: import path { inherit lib sources self; };
  in
  {
    filesystem = lib.filesystem // (callLib ./filesystem.nix);
    flakes = lib.flakes // (callLib ./flakes.nix);
    options = lib.options // (callLib ./options.nix);
    time = callLib ./time.nix;
    trivial = lib.trivial // (callLib ./trivial.nix);
    types = lib.types // (callLib ./types.nix);

    inherit (self.filesystem)
      listFiles
      listDirs
      listNixFiles
      listFilesRecursive
      ;
    inherit (self.flakes) compat compat' package;
    inherit (self.options)
      enumOptionValues
      enumOptionValues'
      mkEnableOptions
      mkEnableOptions'
      ;
    inherit (self.trivial)
      capitalize
      hexToRgba
      isx86Linux
      unreachable
      shortRev
      ;
    inherit (self.types) enumValues unwrapNullOr;

    # Flake Parts
    flake-parts = import "${sources.flake-parts}/lib.nix" { inherit lib; };
    inherit (self.flake-parts) mkFlake;

    # wlib
    wrappers = import "${sources.nix-wrapper-modules}/lib" { inherit lib; };
    mkWrapper = self.wrappers.evalPackage; # should we include self.wrappers.modules.default?
    mkWrapperFor =
      name: module:
      (self.wrappers.evalModules {
        modules = [
          # we can't `{ inherit pkgs; }` sadly
          self.wrappers.wrapperModules.${name}
          module
        ];
      }).config.wrapper;
  }
)
