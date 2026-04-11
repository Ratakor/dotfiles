# TODO: should this be exposed by the flake as a package output?
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellApplication;

  callScript =
    path:
    import path {
      inherit
        config
        lib
        pkgs
        self
        ;
    };
in
{
  # TODO:
  # dmenurecord: replace with wf-recorder
  # dmenusearch: split into different package since it has so many dependencies?
  # icstocal: merge with quand?
  # plumber: ..., support archive/compressed files
  # screenshot: remove? rewrite using nix, depends on dmenurecord
  # ytdl: ...
  hm.home.file."${config.user.home}/.local/bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };

  user.packages = [
    (callScript ./src/emojisearch)
    (callScript ./src/music)
    (callScript ./src/musiccmd.nix)
    (callScript ./src/randwp.nix)

    (writeShellApplication {
      name = "glitchlock";
      runtimeInputs = with pkgs; [
        grim
        imagemagick
        coreutils
        swaylock
      ];
      text = readFile ./src/glitchlock.sh;
    })

    (writeShellApplication {
      name = "battery";
      runtimeInputs = with pkgs; [
        coreutils
        libnotify
      ];
      text = readFile ./src/battery.sh;
    })

    (writeShellApplication {
      name = "sci";
      runtimeInputs = with pkgs; [
        git
        coreutils
      ];
      text = readFile ./src/sci.sh;
    })

    # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/cli/wayland.nix
    (writeShellApplication {
      name = "ocr";
      runtimeInputs = with pkgs; [
        tesseract
        grim
        slurp
        libnotify
        coreutils
      ];
      text = readFile ./src/ocr.sh;
    })

    # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/dev/default.nix
    (writeShellApplication {
      name = "pdflatexmk";
      runtimeInputs = [ pkgs.texlivePackages.latexmk ];
      text = ''
        latexmk -pdf "$@" && latexmk -c "$@"
      '';
    })

    # convert markdown to pdf with pandoc
    # assuming that first argument is the markdown file
    (writeShellApplication {
      name = "pdfmd";
      runtimeInputs = with pkgs; [
        pandoc
        gnused
      ];
      text = ''
        pandoc "$@" -o "$(printf '%s' "$1" | sed 's/.md/.pdf/g') -V geometry:margin=1in"
      '';
    })

    (writeShellApplication {
      name = "help";
      runtimeInputs = [ pkgs.bat ];
      text = ''
        "$@" --help 2>&1 | bat -p -l help
      '';
    })

    (writeShellApplication {
      name = "real";
      runtimeInputs = with pkgs; [
        coreutils
        which
      ];
      text = ''
        realpath "$(which "$1")"
      '';
    })
  ];
}
