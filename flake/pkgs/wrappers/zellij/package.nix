# Terminal multiplexer & session manager
{
  zellij,
  symlinkJoin,
  makeWrapper,
  writeTextFile,

  colors,
}@args:
let
  inherit (builtins) readFile;

  colors = args.colors.default;

  config = writeTextFile {
    name = "zellij-config.kdl";
    text = (/* kdl */ ''
      theme "nix"
      themes {
        nix {
          fg "#${colors.foreground}"
          bg "#${colors.background}"
          black "#${colors.black}"
          red "#${colors.red}"
          green "#${colors.green}"
          yellow "#${colors.yellow}"
          blue "#${colors.blue}"
          magenta "#${colors.magenta}"
          cyan "#${colors.cyan}"
          white "#${colors.white}"
          orange "#${colors.orange}"
        }
      }
    '')
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
