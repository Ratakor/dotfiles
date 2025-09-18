# Editor
{ self, ... }:
{
  user.packages = [ self.pkgs.neovim-wrapped ];

  hm.home.shellAliases = {
    vimdiff = "nvim -d";
  };
}
