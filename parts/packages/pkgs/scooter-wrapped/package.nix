{
  pkgs,
  pins,
  scooter,
  runCommandLocal,
  symlinkJoin,
  makeWrapper,
  theme ? "gruvbox-dark",
}:
let
  inherit (pins) gruvbox-tmTheme dracula-tmTheme;

  toml = pkgs.formats.toml { };

  configDir = runCommandLocal "scooter-config-dir" { } ''
    mkdir -p $out/etc/themes
    ln -s "${toml.generate "scooter-config.toml" settings}" $out/etc/config.toml
    ln -s "${gruvbox-tmTheme + /gruvbox-dark.tmTheme}" $out/etc/themes/gruvbox-dark.tmTheme
    ln -s "${gruvbox-tmTheme + /gruvbox-light.tmTheme}" $out/etc/themes/gruvbox-light.tmTheme
    ln -s "${dracula-tmTheme + /Dracula.tmTheme}" $out/etc/themes/dracula.tmTheme
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
