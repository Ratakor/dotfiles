# Guess what this is
{ pkgs, ... }:
let
  # gitui v0.22.1 got better controls but recent versions are more performant
  gitui_0_22_1 = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "gitui";
    version = "0.22.1";

    src = pkgs.fetchzip {
      url = "https://github.com/extrawurst/gitui/releases/download/v${finalAttrs.version}/gitui-linux-musl.tar.gz";
      hash = "sha256-a4u38ywgA3IB4Or3Cr5JCrUfF6R9cWQKEF/0hk9tLO8=";
    };

    installPhase = ''
      install -Dm755 gitui $out/bin/gitui
    '';

    inherit (pkgs.gitui) meta;
  });
in
{
  hm.programs.gitui = {
    enable = true;

    # package = gitui_0_22_1;
    # keyConfig = ./key_bindings_0.22.1.ron;
    keyConfig = ./key_bindings.ron;

    # theme = # default
  };
}
