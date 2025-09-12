# Terminal File Manager
{
  yazi,
  yaziPlugins,
  bat,
  ouch,
  mediainfo,
  ueberzugpp,
  dragon-drop,
  ...
}:
let
  fromTOML = file: builtins.readFile file |> builtins.fromTOML;
in
yazi.override {
  initLua = ./init.lua;

  settings = {
    keymap = fromTOML ./keymap.toml;
    yazi = fromTOML ./yazi.toml;
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

    # TODO: custom scripts
    # randwp
    # plumber
  ];
}
