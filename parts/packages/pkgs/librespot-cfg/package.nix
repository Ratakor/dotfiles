{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  zig_0_15,
  librespot,
  releaseMode ? "ReleaseFast",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "librespot-cfg";
  version = librespot.version;

  src = fetchurl {
    url = "https://gist.githubusercontent.com/Ratakor/7dab4b17311a5c60d3b36ad34a02388a/raw/e51aa5725778e52cc9f53faa978f53c5908b51f4/librespot-cfg.zig";
    hash = "sha256-NhdPQOiAbW3W4XWxcILC7wZTODHyq2gRDWe3GcAHz3I=";
  };

  nativeBuildInputs = [
    zig_0_15
    makeWrapper
  ];

  buildInputs = [
    librespot
  ];

  dontUnpack = true;

  buildPhase = ''
    export ZIG_GLOBAL_CACHE_DIR=$PWD/zig-cache
    export ZIG_LOCAL_CACHE_DIR=$ZIG_GLOBAL_CACHE_DIR
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
    zig build-exe -O ${releaseMode} $src --name librespot-cfg
  '';

  installPhase = ''
    install -Dm755 librespot-cfg $out/bin/librespot-cfg
    wrapProgram $out/bin/librespot-cfg \
      --suffix PATH : ${lib.makeBinPath [librespot]}
  '';

  meta = {
    description = "A wrapper around librespot to support file configuration";
    homepage = "https://gist.github.com/Ratakor/7dab4b17311a5c60d3b36ad34a02388a";
    licence = lib.licenses.mit;
    mainProgram = "librespot-cfg";
  };
})
