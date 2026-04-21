{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.editor.neovim.enable {
    self.programs.default.editor = mkIf (prg.default.editor.name == "neovim") {
      cmd = "nvim";
      desktopEntry = "nvim.desktop";
    };

    user.packages = [ self.pkgs.neovim-wrapped ];

    hm.home.shellAliases = {
      vimdiff = "nvim -d";
    };
  };
}
