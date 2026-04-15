{
  fetchFromGitHub,
  niri,
  pins,
  date,
  rustPlatform,
}:
let
  pin = pins.niri;
in
niri.overrideAttrs rec {
  version = "0-unstable-${date}";

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
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  doInstallCheck = false; # fail version check
}
