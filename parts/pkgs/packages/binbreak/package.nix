{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "binbreak";
  version = "0.2.0-alpha";

  src = fetchFromGitHub {
    owner = "epic-64";
    repo = "binbreak";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RZkf5SXh+TKFv+5QToOv/Lxx7sVywsZkKjkX6/T3T/M=";
  };

  cargoHash = "sha256-XJEYxj5vycfkpldRT0Up1XRZqSiZxHhlQLeiBS52FxU=";

  meta = {
    description = "A terminal based binary number guessing game";
    homepage = "https://github.com/epic-64/binbreak";
    # license = lib.licenses.
    maintainers = [ lib.maintainers.ratakor ];
    mainProgram = "binbreak";
  };
})
