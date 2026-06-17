{
  writeShellApplication,
  bat,
}:
writeShellApplication {
  name = "help";
  runtimeInputs = [
    bat
  ];
  text = ''
    "$@" --help 2>&1 | bat -p -l help
  '';
  meta.mainProgram = "help";
}
