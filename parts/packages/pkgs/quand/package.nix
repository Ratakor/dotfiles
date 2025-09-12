# requires coreutils and util-linux but I cba make a wrapper for them
# also find a way to use dash instead of bash for interpreting
{
  stdenv,
  lib,
  fetchFromGitHub,
}:
let
  rev = "5894842960a09e2d3b35eba3900c548a781001e5";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "quand";
  version = "0.4-${rev}";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "ratakor";
    repo = "quand";
    inherit rev;
    hash = "sha256-PbBadaunDCaey52C2ZVtdM84mC1iDXKGmSQmDqVe0zQ=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple calendar written in POSIX sh";
    homepage = "https://github.com/ratakor/quand";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.ratakor ];
    mainProgram = "quand";
  };
})
