{ lib, self, ... }:
let
  inherit (builtins) substring;
  inherit (lib.modules) mkForce;

  date = substring 0 8 (self.lastModifiedDate or "19700101");
  rev = self.shortRev or self.dirtyShortRev or "dirty";
in
{
  # This is almost the same as nixpkgs's flake's default (see nixpkgs/lib/flake-version-info.nix).
  # We override it because I don't like the raw default of nixpkgs (see lib.trivial.versionSuffix).
  system.nixos.versionSuffix = mkForce ".${date}.${rev}";
}
