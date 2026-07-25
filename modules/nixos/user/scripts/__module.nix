{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optional;

  prg = config.self.programs;
  cfg = prg.scripts;
in
{
  config = mkIf cfg.enable {
    user.packages = concatLists [
      # TODO: probably move this to programs/locker
      # swaylock too
      # also rename to lock instead of locker?
      (optional prg.locker.glitchlock.enable (pkgs.scripts.glitchlock.override { isWayland = true; }))

      (optional cfg.ocr.enable (pkgs.scripts.ocr.override { isWayland = true; }))
      (optional cfg.pdfmd.enable pkgs.scripts.pdfmd)
      [
        pkgs.scripts.real
        pkgs.scripts.sci
        pkgs.scripts.ytdl

        # TODO: support archive/compressed files? (ouch is already goated)
        # TODO: override prelude?
        pkgs.scripts.plumber
      ]
    ];
  };
}
