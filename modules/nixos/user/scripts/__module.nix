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
  inherit (lib.meta) getExe';
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
  dprg = prg.default;
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
      (optional prg.locker.glitchlock.enable (pkgs.scripts.glitchlock.override { isWayland = true; }))
      (optional cfg.ocr.enable pkgs.scripts.ocr)
      (optional cfg.pdfmd.enable pkgs.scripts.pdfmd)
      (optional cfg.randwp.enable (
        pkgs.scripts.randwp.override {
          isWayland = true;
          supportMultipleMonitors = true; # builtins.length config.self.device.monitors > 1;
          inherit (config.self) wallpapers;
        }
      ))
      [
        (pkgs.scripts.emojisearch.override {
          dmenuCommand = dprg.launcher.dmenu;
          copyCommand = getExe' pkgs.wl-clipboard "wl-copy";
        })
        pkgs.scripts.sci
        pkgs.scripts.battery
        pkgs.scripts.pdflatexmk
        pkgs.scripts.help
        pkgs.scripts.real

        # TODO: to deprecate
        (callScript ./src/music)
        (callScript ./src/musiccmd)
      ]
    ];
  };
}
