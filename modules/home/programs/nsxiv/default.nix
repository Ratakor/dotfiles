# New Suckless X Image Viewer
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

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
  config = mkIf (config.self.displayServer == "x11") {
    user.packages = [ nsxiv ];
  };
}
