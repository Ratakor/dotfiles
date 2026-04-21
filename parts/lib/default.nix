{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (self) pins;
in
{
  # Expose the lib via the flake using flake-parts.
  # I could merge this lib with nixpkgs.lib but I chose not to because
  # namespacing is important. By setting this lib as a flake output we can also
  # reference it using `self.lib` which makes sense.
  # See NotAShelf/nyx/parts/lib/default.nix for an example of how to
  # beautifully merge libs though.
  flake.lib = lib.makeExtensible (
    self:
    let
      callLib =
        path:
        import path {
          inherit
            inputs
            lib
            pins
            self
            ;
        };
    in
    {
      filesystem = callLib ./filesystem.nix;
      flake = callLib ./flake.nix;
      options = callLib ./options.nix;
      time = callLib ./time.nix;
      trivial = callLib ./trivial.nix;
      types = callLib ./types.nix;

      inherit (self.filesystem) listFiles listDirs;
      inherit (self.flake) compat compat' package;
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
        ;
      inherit (self.types) enumValues unwrapNullOr;
    }
  );
}
