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
  config = lib.mkIf prg.fileManager.dolphin.enable {
    user.packages = [ pkgs.dolphin ];
  };
}
