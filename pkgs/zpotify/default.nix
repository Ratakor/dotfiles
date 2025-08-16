{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  zig_0_13,
  pkg-config,
  glib,
  chafa,
  libjpeg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zpotify";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ratakor";
    repo = "zpotify";
    tag = "${finalAttrs.version}";
    hash = "sha256-xJKr4w5HVqzQt61xifXjybjgesYNuQsAF+wn2sG5cIY=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    zig_0_13.hook
  ];

  buildInputs = [
    glib # chafa dependency
    chafa
    libjpeg
  ];

  # https://ryantm.github.io/nixpkgs/hooks/installShellFiles
  postInstall = ''
    installShellCompletion --cmd zpotify \
      --zsh _zpotify
  '';

  meta = {
    description = "A CLI/TUI for Spotify written in Zig";
    homepage = "https://github.com/ratakor/zpotify";
    licence = lib.licenses.gpl3Plus;
    maintainers = [];
    mainProgram = "zpotify";
  };
})
