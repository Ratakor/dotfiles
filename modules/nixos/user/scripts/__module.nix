# TODO: should this be exposed by the flake as a package output?
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (pkgs) callPackage;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optional;

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
        (callPackage ./src/battery { })
        (callPackage ./src/real { })
        (callPackage ./src/sci { })
        (callPackage ./src/ytdl { })
      ]
    ];
  };
}
