let
  keys = import ../parts/keys.nix;
  inherit (keys) all;
in
{
  "irc.age".publicKeys = all;
  "git-epita.age".publicKeys = all;
}
