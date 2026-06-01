{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.programs.apps.onlyoffice;
in
{
  config = mkIf cfg.enable {
    user.packages = [ pkgs.onlyoffice-desktopeditors ];

    # https://github.com/ONLYOFFICE/DocumentServer/issues/1859
    fonts.packages = [ pkgs.corefonts ];
  };
}
