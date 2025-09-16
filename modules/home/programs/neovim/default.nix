# Editor
{ self, ... }:
{
  user.packages = [ self.pkgs.neovim-wrapped ];
}
