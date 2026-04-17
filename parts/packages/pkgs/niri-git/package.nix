{
  fetchFromGitHub,
  niri,
  pins,
  rustPlatform,
}:
let
  inherit (builtins) substring;

  pin = pins.niri;
in
niri.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0-unstable-${substring 0 7 pin.revision}";

    src = fetchFromGitHub {
      owner = "niri-wm";
      repo = "niri";
      rev = pin.revision;
      inherit (pin) hash;
    };

    postPatch = ''
      patchShebangs resources/niri-session
      substituteInPlace resources/niri.service \
        --replace-fail 'ExecStart=niri' "ExecStart=$out/bin/niri"
    '';

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${finalAttrs.src}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };

    doInstallCheck = false; # fail version check
  }
)
