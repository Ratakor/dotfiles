{lib}:
lib.makeExtensible (
  self: let
    callLib = file: import file {inherit lib self;};
  in {
    trivial = callLib ./trivial.nix;

    inherit
      (self.trivial)
      capitalize
      hexToRgba
      ;
  }
)
