{
  mkShellNoCC,
  zig,
  zls,
  zon2nix,
  gnutar,
  xz,
  p7zip,
}:
mkShellNoCC {
  packages = [
    zig
    zls
    zon2nix

    # `zig build release` dependencies
    gnutar
    xz
    p7zip
  ];
}
