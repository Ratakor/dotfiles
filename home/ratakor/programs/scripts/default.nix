{pkgs, ...}: {
  imports = [
    ./bin.nix # TODO: merge it here
  ];

  home.packages = [
    (pkgs.writeShellApplication {
      name = "pdfmd";
      runtimeInputs = with pkgs; [pandoc gnused];
      # '-V geometry:margin=1in' is probably good but I forgot what it does
      text = ''
        pandoc "$1" -o "$(printf '%s' "$1" | sed 's/.md/.pdf/g')"
      '';
    })

    # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/dev/default.nix
    (pkgs.writeShellApplication {
      name = "pdflatexmk";
      runtimeInputs = [pkgs.texlivePackages.latexmk];
      text = ''
        latexmk -pdf "$@" && latexmk -c "$@"
      '';
    })

    # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/cli/wayland.nix
    (pkgs.writeShellApplication {
      name = "ocr";
      runtimeInputs = with pkgs; [tesseract grim slurp libnotify coreutils];
      text = ''
        echo "Generating a random ID..."
        id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
        echo "Image ID: $id"

        echo "Taking screenshot..."
        grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr-"$id".png

        echo "Running OCR..."
        tesseract /tmp/ocr-"$id".png - | wl-copy
        echo -en "File saved to /tmp/ocr-'$id'.png\n"

        echo "Sending notification..."
        notify-send "OCR " "Text copied!"

        echo "Cleaning up..."
        rm /tmp/ocr-"$id".png -vf

      '';
    })
  ];
}
