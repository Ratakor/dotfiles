{
  writeShellApplication,
  coreutils,
  which,
}:
writeShellApplication {
  name = "real";
  runtimeInputs = [
    coreutils
    which
  ];
  text = ''
    realpath "$(which "$1")"
  '';
  meta.mainProgram = "real";
}
