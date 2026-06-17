{
  writeShellApplication,
  coreutils,
  libnotify,
}:
writeShellApplication {
  name = "battery";
  runtimeInputs = [
    # coreutils
    # libnotify
  ];
  text = builtins.readFile ./battery.sh;
  meta.mainProgram = "battery";
}
