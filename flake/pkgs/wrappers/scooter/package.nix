{
  pkgs,
  sources,
  scooter,
  runCommandLocal,
  symlinkJoin,
  makeWrapper,
  colors,
  theme ? colors.default.scooter.theme,
}:
let
  inherit (sources) gruvbox-tmTheme dracula-tmTheme;

  toml = pkgs.formats.toml { };

  # We should probably only link to the chosen theme
  configDir = runCommandLocal "scooter-config-dir" { } ''
    mkdir -p $out/etc/themes
    ln -s "${toml.generate "scooter-config.toml" settings}" $out/etc/config.toml
    ln -s "${gruvbox-tmTheme + "/gruvbox-dark.tmTheme"}" $out/etc/themes/gruvbox-dark.tmTheme
    ln -s "${gruvbox-tmTheme + "/gruvbox-light.tmTheme"}" $out/etc/themes/gruvbox-light.tmTheme
    ln -s "${dracula-tmTheme + "/Dracula.tmTheme"}" $out/etc/themes/dracula.tmTheme
  '';

  settings = {
    preview = {
      syntax_highlighting_theme = theme;
    };
    keys = {
      general = {
        quit = [
          "C-c"
          "esc"
        ];
      };
    };
  };
in
symlinkJoin {
  inherit (scooter) pname version meta;
  paths = [
    scooter
    configDir
  ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/scooter" \
      --add-flag "--config-dir" \
      --add-flag "$out/etc"
  '';
}
