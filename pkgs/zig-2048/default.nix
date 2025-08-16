{
  stdenv,
  lib,
  fetchFromGitHub,
  zig_0_14,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zig-2048";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "ratakor";
    repo = "2048.zig";
    tag = "${finalAttrs.version}";
    hash = "sha256-SpHLs8SAFpYdlXPaMAr19CDYTQil1XoZMhw4VP34WQg=";
  };

  nativeBuildInputs = [
    zig_0_14.hook
  ];

  meta = {
    description = "A terminal version of the 2048 game";
    homepage = "https://github.com/ratakor/2048.zig";
    licence = lib.licenses.isc;
    maintainers = [];
    mainProgram = "2048";
  };
})
