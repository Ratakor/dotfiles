{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "v-analyzer";
  version = "0.0.6";

  src = fetchzip {
    url = "https://github.com/vlang/v-analyzer/releases/download/${finalAttrs.version}/v-analyzer-linux-x86_64.zip";
    hash = "sha256-8tut1fz0qrn1dt9vZl+OfY7yjXKXW/olqQbI+bU1l9I=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 v-analyzer $out/bin/v-analyzer
    runHook postInstall
  '';

  meta = {
    description = "The vlang language server";
    homepage = "https://github.com/vlang/v-analyzer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratakor ];
    platforms = lib.platforms.x86_64-linux;
  };
})
