{
  config,
  lib,
  pkgs,
  ...
}:
let
  prg = config.self.programs;
in
{
  config = lib.mkIf prg.fileManager.nautilus.enable {
    user.packages = [ pkgs.nautilus ];
  };
}
