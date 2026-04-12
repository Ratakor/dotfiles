{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.programs.editor.program == "neovim") {
    self.programs.editor = {
      cmd = "nvim";
      desktopEntry = "nvim.desktop";
    };

    user.packages = [ self.pkgs.neovim-wrapped ];

    hm.home.shellAliases = {
      vimdiff = "nvim -d";
    };
  };
}
