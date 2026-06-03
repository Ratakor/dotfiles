{
  writeShellApplication,
  git,
  coreutils,
}:
writeShellApplication {
  name = "sci";
  runtimeInputs = [
    git
    coreutils
  ];
  text = builtins.readFile ./sci.sh;
}
