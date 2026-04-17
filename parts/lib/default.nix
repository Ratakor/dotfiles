{ lib, ... }:
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
      callLib = path: import path { inherit lib self; };
    in
    {
      filesystem = callLib ./filesystem.nix;
      time = callLib ./time.nix;
      trivial = callLib ./trivial.nix;

      inherit (self.filesystem) listFiles listDirs;
      inherit (self.trivial)
        capitalize
        hexToRgba
        isx86Linux
        unreachable
        ;
    }
  );
}
