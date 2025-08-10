{
  colors,
  config,
  pkgs,
  ...
}: {
  # TODO:
  # dmenurecord: replace with wf-recorder
  # dmenusearch: split into different package since it has so many dependencies?
  # ex: merge with plumber?
  # hole: remove?
  # icstocal: merge with quand?
  # mail: replace with a better mail client
  # music/musiccmd: ...
  # plumber: ...
  # randwp: ...
  # screenshot: ... depends on dmenurecord
  # ytdl: ...
  home.file."${config.home.homeDirectory}/.local/bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };

  xdg.dataFile.emoji.source = ./src/emoji;

  home.packages = [
    (import ./shutdown-menu.nix {inherit colors pkgs;})

    (pkgs.writeShellApplication {
      name = "glitchlock";
      runtimeInputs = with pkgs; [grim imagemagick coreutils swaylock];
      text = builtins.readFile ./src/glitchlock.sh;
    })

    (pkgs.writeShellApplication {
      name = "battery";
      runtimeInputs = with pkgs; [coreutils libnotify];
      text = builtins.readFile ./src/battery.sh;
    })

    # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/cli/wayland.nix
    (pkgs.writeShellApplication {
      name = "ocr";
      runtimeInputs = with pkgs; [tesseract grim slurp libnotify coreutils];
      text = builtins.readFile ./src/ocr.sh;
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

    (pkgs.writeShellApplication {
      name = "real";
      runtimeInputs = [pkgs.coreutils];
      text = ''
        # shellcheck disable=SC2046
        realpath $(where "$1")
      '';
    })
  ];
}
