# Terminal multiplexer & session manager
{
  zellij,
  symlinkJoin,
  makeWrapper,
  writeTextFile,
  colors,
  theme ? colors.default.zellij.theme,
}:
let
  inherit (builtins) readFile;

  config = writeTextFile {
    name = "zellij-config.kdl";
    text = ''
      theme "${theme}"
    ''
    + readFile ./common.kdl;
  };
in
symlinkJoin {
  inherit (zellij) pname version meta;
  paths = [ zellij ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/zellij" \
      --add-flag "--config" \
      --add-flag "${config}"
  '';
}
