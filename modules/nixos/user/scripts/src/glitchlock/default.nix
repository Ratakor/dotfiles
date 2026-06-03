{
  writeShellApplication,
  grim,
  imagemagick,
  coreutils,
  swaylock,
}:
writeShellApplication {
  name = "glitchlock";
  runtimeInputs = [
    grim
    imagemagick
    coreutils
    swaylock
  ];
  text = builtins.readFile ./glitchlock.sh;
}
