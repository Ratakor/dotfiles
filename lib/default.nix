{lib, ...}: {
  capitalize = import ./capitalize.nix {inherit lib;};
  hexToRgba = import ./hexToRgba.nix {inherit lib;};
}
