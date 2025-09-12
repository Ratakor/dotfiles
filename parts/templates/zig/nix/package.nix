{
  lib,
  stdenv,
  zig,
}:
let
  fs = lib.fileset;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zig-template";
  # Must match the `version` in `build.zig.zon`.
  version = "0.1.0-dev";

  src = fs.toSource {
    root = ../.;
    fileset = fs.unions [
      ../src
      ../build.zig
      ../build.zig.zon
    ];
  };

  # deps = callPackage ./deps.nix { };

  zigBuildFlags = [
    # "--system"
    # "${finalAttrs.deps}"
    "-Dversion-string=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    zig.hook
  ];
})
