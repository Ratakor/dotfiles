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
  text = builtins.readFile ./real.sh;
}
