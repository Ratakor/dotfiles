{
  writeShellApplication,
  git,
  coreutils,
}:
writeShellApplication {
  name = "sci";
  runtimeInputs = [
    coreutils
    git
  ];
  text = builtins.readFile ./sci.sh;
  meta.mainProgram = "sci";
}
