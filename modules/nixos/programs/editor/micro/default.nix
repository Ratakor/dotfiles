# normie text editor
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.micro;
in
{
  config = mkIf prg.editor.micro.enable {
    self.programs.default.editor = mkIf (prg.default.editor.name == "micro") {
      inherit package;
    };

    user.packages = [ package ];
  };
}
