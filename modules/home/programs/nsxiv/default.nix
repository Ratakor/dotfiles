# New Suckless X Image Viewer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  # TODO:
  # - add -a patch
  # - fetch nsxiv-extra (with npins?) for zsh completion & patches
  nsxiv = pkgs.nsxiv.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or [ ]) ++ [ ./image-mode-cycle-v30.diff ];

    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.installShellFiles ];
    postInstall = (prevAttrs.postInstall or "") + ''
      installShellCompletion --cmd nsxiv \
        --zsh ${./_nsxiv}
    '';
  });
in
{
  config = mkIf (config.self.programs.imageViewer.program == "nsxiv") {
    user.packages = [ nsxiv ];

    hm.xdg.desktopEntries.nsxiv-a = {
      name = "nsxiv";
      exec = "nsxiv -a %f";
    };

    self.programs.imageViewer = {
      cmd = "nsxiv -a";
      desktopEntry = "nsxiv-a.desktop";
    };
  };
}
