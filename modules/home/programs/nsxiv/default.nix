# New Suckless X Image Viewer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  # TODO:
  # - add -a patch
  # - fetch nsxiv-extra (with npins?) for zsh completion & patches
  package = pkgs.nsxiv.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or [ ]) ++ [ ./image-mode-cycle-v30.diff ];

    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.installShellFiles ];
    postInstall = (prevAttrs.postInstall or "") + ''
      installShellCompletion --cmd nsxiv \
        --zsh ${./_nsxiv}
    '';
  });
in
{
  config = mkIf prg.imageViewer.nsxiv.enable {
    self.programs.default.imageViewer = mkIf (prg.default.imageViewer.name == "nsxiv") {
      inherit package;
    };

    user.packages = [ package ];
  };
}
