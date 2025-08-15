{pkgs}: let
  inherit (pkgs) lib;
in {
  capitalize = import ./capitalize.nix {inherit lib;};
  hexToRgba = import ./hexToRgba.nix {inherit lib;};
}
