# TODO: should this be exposed by the flake as a package output?
{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (pkgs) writeShellApplication callPackage;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optional;

  # TODO: replace with callPackage
  callScript =
    path:
    import path {
      inherit
        config
        lib
        pkgs
        sources
        ;
    };

  prg = config.self.programs;
  cfg = prg.scripts;
in
{
  config = mkIf cfg.enable {
    # TODO:
    # dmenurecord: replace with wf-recorder
    # dmenusearch: split into different package since it has so many dependencies?
    # icstocal: merge with quand?
    # plumber: ..., support archive/compressed files
    # screenshot: remove? rewrite using nix, depends on dmenurecord
    # ytdl: ...
    hm.home.file.".local/bin" = {
      source = ./bin;
      recursive = true;
      executable = true;
    };

    user.packages = concatLists [
      (optional prg.locker.glitchlock.enable (callPackage ./src/glitchlock { }))
      (optional cfg.ocr.enable (callPackage ./src/ocr { }))
      (optional cfg.pdfmd.enable (callPackage ./src/pdfmd { }))
      (optional cfg.randwp.enable (callScript ./src/randwp))
      [
        (callScript ./src/emojisearch)
        (callScript ./src/music)
        (callScript ./src/musiccmd)

        (callPackage ./src/battery { })
        (callPackage ./src/sci { })

        # from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/dev/default.nix
        (writeShellApplication {
          name = "pdflatexmk";
          runtimeInputs = [ pkgs.texlivePackages.latexmk ];
          text = ''
            latexmk -pdf "$@" && latexmk -c "$@"
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
      ]
    ];
  };
}
