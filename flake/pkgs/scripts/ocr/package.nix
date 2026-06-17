# from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/cli/wayland.nix
# TODO: add x11 support
{
  writeShellApplication,
  tesseract,
  grim,
  slurp,
  libnotify,
  coreutils,
  wl-clipboard,
}:
writeShellApplication {
  name = "ocr";
  runtimeInputs = [
    tesseract # This is 1GiB
    grim
    slurp
    # libnotify
    # coreutils
    wl-clipboard
  ];
  text = builtins.readFile ./ocr.sh;
  meta.mainProgram = "ocr";
}
