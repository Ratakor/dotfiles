{
  colors,
  pkgs,
  ...
}: {
  imports = [
    ./bin.nix # TODO: merge it here
  ];

  xdg.dataFile.emoji.source = ./src/emoji;

  home.packages = [
    (import ./ocr.nix {inherit pkgs;})
    (import ./shutdown-menu.nix {inherit colors pkgs;})

    (pkgs.writeShellApplication {
      name = "glitchlock";
      runtimeInputs = with pkgs; [grim imagemagick coreutils swaylock];
      text = builtins.readFile ./src/glitchlock.sh;
    })

    # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/dev/default.nix
    (pkgs.writeShellApplication {
      name = "pdflatexmk";
      runtimeInputs = [pkgs.texlivePackages.latexmk];
      text = ''
        latexmk -pdf "$@" && latexmk -c "$@"
      '';
    })

    # convert markdown to pdf with pandoc
    # assuming that first argument is the markdown file
    (pkgs.writeShellApplication {
      name = "pdfmd";
      runtimeInputs = with pkgs; [pandoc gnused];
      # '-V geometry:margin=1in' is probably good but I forgot what it does
      text = ''
        pandoc "$@" -o "$(printf '%s' "$1" | sed 's/.md/.pdf/g')"
      '';
    })

    (pkgs.writeShellApplication {
      name = "help";
      runtimeInputs = [pkgs.bat];
      text = ''
        "$@" --help 2>&1 | bat -p -l help
      '';
    })
  ];
}
