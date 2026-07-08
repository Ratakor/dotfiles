# requires coreutils and util-linux but I cba make a wrapper for them
# also find a way to use dash instead of bash for interpreting
{
  stdenv,
  lib,
  fetchFromGitHub,
}:
let
  inherit (builtins) substring;

  # why aren't we using npins?
  # well idk but I won't update this until quand is rewritten in a proper language
  # PS: when will this be rewritten in rust or something???
  rev = "5894842960a09e2d3b35eba3900c548a781001e5";
in
stdenv.mkDerivation {
  pname = "quand";
  version = "0.4-${substring 0 7 rev}";

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
}
