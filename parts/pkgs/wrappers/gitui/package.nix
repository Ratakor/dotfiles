# TUI for git (shocking)
{
  gitui,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  inherit (gitui) pname version meta;
  paths = [ gitui ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/gitui" \
      --add-flag "--key-bindings" \
      --add-flag "${./key_bindings.ron}"
  '';
}
