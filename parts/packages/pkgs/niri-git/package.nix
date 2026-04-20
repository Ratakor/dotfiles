{
  fetchFromGitHub,
  niri,
  pins,
  rustPlatform,
}:
let
  pin = pins.niri;
  shortRev = builtins.substring 0 7 pin.revision;
in
niri.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "0-unstable-${shortRev}-0";

    src = fetchFromGitHub {
      inherit (pin) hash;
      inherit (pin.repository) owner repo;
      rev = pin.revision;
    };

    outputs = [ "out" ];

    preCheck = ''
      export XDG_RUNTIME_DIR="$(mktemp -d)"
    '';

    postPatch = ''
      patchShebangs resources/niri-session
      substituteInPlace resources/niri.service \
        --replace-fail 'ExecStart=niri' "ExecStart=$out/bin/niri"
    '';

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${finalAttrs.src}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };

    env.NIRI_BUILD_COMMIT = shortRev;

    doInstallCheck = false; # fail version check
  }
)
