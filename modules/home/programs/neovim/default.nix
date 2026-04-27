{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  package = pkgs.wrappers.neovim;
in
{
  config = mkIf prg.editor.neovim.enable {
    self.programs.default.editor = mkIf (prg.default.editor.name == "neovim") {
      cmd = "nvim";
      inherit package;
    };

    user.packages = [ package ];

    hm.home.shellAliases = {
      vimdiff = "nvim -d";
    };
  };
}
