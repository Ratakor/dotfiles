{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      luciole-fonts = super.callPackage ./luciole-fonts.nix {};
    })
  ];
}
