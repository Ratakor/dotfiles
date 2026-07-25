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
      # TODO: probably move this to programs/locker
      # swaylock too
      # also rename to lock instead of locker?
      (optional prg.locker.glitchlock.enable (pkgs.scripts.glitchlock.override { isWayland = true; }))

      (optional cfg.ocr.enable (pkgs.scripts.ocr.override { isWayland = true; }))
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
