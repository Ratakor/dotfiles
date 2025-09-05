{
  mkShellNoCC,
  bash,
  zig,
  zls,
  gnutar,
  xz,
  p7zip,
}:
mkShellNoCC {
  packages = [
    bash # required by zig-flake
    zig
    zls

    # `zig build release` dependencies
    gnutar
    xz
    p7zip
  ];
}
