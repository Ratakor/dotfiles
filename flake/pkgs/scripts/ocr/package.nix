# from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/cli/wayland.nix
{
  lib,
  writeShellApplication,
  tesseract,
  grim,
  slurp,
  maim,
  libnotify,
  coreutils,
  wl-clipboard,

  isWayland ? false,
}:
let
  inherit (lib.meta) getExe;

  screenshot =
    if isWayland then
      "${getExe grim} -g \"$(${getExe slurp} -w 0 -b eebebed2)\""
    else
      "${getExe maim} -u -s";
in
writeShellApplication {
  name = "ocr";
  runtimeInputs = [
    tesseract # This is 1GiB
    libnotify
    coreutils
    wl-clipboard
  ];
  text = ''
    printf 'Generating a random ID...\n'
    id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
    printf 'Image ID: %s\n' "$id"

    printf 'Taking screenshot...\n'
    ${screenshot} "/tmp/ocr-$id.png"

    printf 'Running OCR...\n'
    tesseract "/tmp/ocr-$id.png" - | wl-copy
    printf 'File saved to /tmp/ocr-%s.png\n' "$id"

    printf 'Sending notification...\n'
    notify-send "OCR " "Text copied!"

    printf 'Cleaning up...\n'
    rm -vf "/tmp/ocr-$id.png"
  '';
  meta.mainProgram = "ocr";
}
