{
  lib,
  stdenvNoCC,
  callPackage,
  zig,
  releaseMode ? "safe",
}:
let
  fs = lib.fileset;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zig-template";
  inherit (import ./version.nix lib) version;

  src = fs.toSource {
    root = ../.;
    fileset = fs.unions [
      ../src
      ../build.zig
      ../build.zig.zon
    ];
  };

  nativeBuildInputs = [
    zig
  ];

  configurePhase = ''
    export ZIG_GLOBAL_CACHE_DIR=$TEMP/.cache
    PACKAGE_DIR=${callPackage ./deps.nix { }}
  '';

  buildPhase = ''
    zig build install \
      --system $PACKAGE_DIR \
      --release=${releaseMode} \
      -Dversion-string=${finalAttrs.version} \
      --color off \
      --prefix $out
  '';

  doCheck = true;
  checkPhase = ''
    zig build test \
      --system $PACKAGE_DIR \
      -Dversion-string=${finalAttrs.version} \
      --color off
  '';

  dontInstall = true;

  meta = {
    mainProgram = "zig-template";
  };
})
