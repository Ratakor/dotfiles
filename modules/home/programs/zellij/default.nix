# Terminal multiplexer & session manager
{ self, ... }:
{
  user.packages = [ self.pkgs.zellij-wrapped ];
}
