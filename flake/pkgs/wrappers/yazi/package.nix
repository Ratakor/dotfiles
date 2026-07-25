# Terminal File Manager
{
  lib,
  scripts,
  yazi,
  yaziPlugins,
  bat,
  ouch,
  mediainfo,
  ueberzugpp,
  dragon-drop,

  setWallpaperCommand ? null,
}:
let
  inherit (builtins) fromTOML readFile;
in
yazi.override {
  initLua = ./init.lua;

  # atp this should probably be configured in nix rather than toml
  settings = {
    yazi = fromTOML (readFile ./yazi.toml);
    keymap = fromTOML (import ./keymap.nix { inherit lib setWallpaperCommand; });
  };

  plugins = {
    inherit (yaziPlugins)
      bypass
      mediainfo
      ouch
      smart-paste
      toggle-pane
      ;
    man = ./plugins/man.yazi;
    text = ./plugins/text.yazi;
    # hexyl: https://github.com/Reledia/hexyl.yazi
  };

  extraPackages = [
    bat # needed for man & text plugins
    ouch
    mediainfo
    ueberzugpp # image preview on terminal emulators that don't have it built-in
    dragon-drop # <C-n>
    scripts.plumber
  ];
}
