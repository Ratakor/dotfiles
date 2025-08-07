{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "luciole-fonts";
  version = "1";

  src = fetchzip {
    url = "https://luciole-vision.com/fonts/Luciole.zip";
    hash = "sha256-Q58petDKiS08gdVRQD/mquxoMYiwjEbWzcWv5soXXE8=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -Dt $out/share/fonts/Luciole Luciole/*.ttf
    runHook postInstall
  '';

  meta = {
    description = "A typeface developed explicitly for visually impaired people";
    homepage = "https://luciole-vision.com";
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.all;
  };
}
