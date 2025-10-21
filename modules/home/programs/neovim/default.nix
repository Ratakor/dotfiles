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
  config = mkIf (config.self.editor.program == "neovim") {
    user.packages = [ self.pkgs.neovim-wrapped ];

    hm.home.shellAliases = {
      vimdiff = "nvim -d";
    };

    self.editor = {
      cmd = "nvim";
      desktopEntry = "nvim.desktop";
    };
  };
}
