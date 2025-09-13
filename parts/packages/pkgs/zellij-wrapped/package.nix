# Terminal multiplexer & session manager
{
  lib,
  zellij,
  runCommand,
  makeWrapper,
  writeTextFile,
  theme ? "gruvbox-dark",
}:
let
  inherit (builtins) readFile;
  inherit (lib.meta) getExe';

  config = writeTextFile {
    name = "zellij-config.kdl";
    text = ''
      theme "${theme}"
    ''
    + readFile ./common.kdl;
  };
in
runCommand zellij.name
  {
    inherit (zellij) pname version meta;
    nativeBuildInputs = [ makeWrapper ];
  }
  ''
    mkdir -p "$out/bin"
    ln -s "${zellij}/share" "$out/share"
    makeWrapper ${getExe' zellij "zellij"} "$out/bin/zellij" \
      --inherit-argv0 \
      --add-flag "--config" \
      --add-flag "${config}"
  ''
