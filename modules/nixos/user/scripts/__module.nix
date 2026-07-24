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
    # icstocal: merge with quand?
    # plumber: ..., support archive/compressed files
    hm.home.file.".local/bin" = {
      source = ./bin;
      recursive = true;
      executable = true;
    };

    user.packages = concatLists [
      (optional prg.locker.glitchlock.enable (callPackage ./src/glitchlock { }))
      (optional cfg.ocr.enable (callPackage ./src/ocr { }))
      (optional cfg.pdfmd.enable (callPackage ./src/pdfmd { }))
      [
        (callScript ./src/emojisearch)

        (callPackage ./src/battery { })
        (callPackage ./src/real { })
        (callPackage ./src/sci { })
        (callPackage ./src/ytdl { })
      ]
    ];
  };
}
