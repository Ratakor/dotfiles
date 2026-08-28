# based on https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/aw/awakened-poe-trade/package.nix
{
  lib,
  fetchurl,
  stdenv,
  appimageTools,
  makeWrapper,
  electron,
  libxtst,
  libxt,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exiled-exchange-2";
  version = "0.15.8";

  src = fetchurl {
    url = "https://github.com/Kvan7/Exiled-Exchange-2/releases/download/v${finalAttrs.version}/Exiled-Exchange-2-${finalAttrs.version}.AppImage";
    hash = "sha256-xmEvKJkRFJokzOa/6qRqT4+QKfnfjIoAfqP+oDqyxH8=";
  };

  passthru = {
    appImageContents = appimageTools.extract {
      inherit (finalAttrs) pname src version;
    };

    updateScript = nix-update-script { };
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/exiled-exchange-2 $out/share/applications

    cp -a ${finalAttrs.passthru.appImageContents}/{locales,resources} $out/share/exiled-exchange-2
    cp -a ${finalAttrs.passthru.appImageContents}/exiled-exchange-2.desktop $out/share/applications/
    cp -a ${finalAttrs.passthru.appImageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/exiled-exchange-2.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=exiled-exchange-2'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/exiled-exchange-2 \
      --add-flags $out/share/exiled-exchange-2/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxtst
          libxt
        ]
      }"
  '';

  meta = {
    description = "Path of Exile 2 trading app for price checking";
    homepage = "https://github.com/Kvan7/Exiled-Exchange-2";
    changelog = "https://github.com/Kvan7/Exiled-Exchange-2/releases/tag/v${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ratakor
    ];
    platforms = lib.platforms.linux;
    mainProgram = "exiled-exchange-2";
  };
})
