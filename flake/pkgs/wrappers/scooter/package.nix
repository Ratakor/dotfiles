{
  pkgs,
  scooter,
  runCommandLocal,
  symlinkJoin,
  makeWrapper,
}:
let
  toml = pkgs.formats.toml { };

  configDir = runCommandLocal "scooter-config-dir" { } ''
    mkdir -p $out/etc
    ln -s "${toml.generate "scooter-config.toml" settings}" $out/etc/config.toml
  '';

  settings = {
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
