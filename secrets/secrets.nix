let
  keys = import ../flake/keys.nix;
  inherit (keys) all;
in
{
  "irc.age".publicKeys = all;
  "git-epita.age".publicKeys = all;
  "anki-key.age".publicKeys = all;
  "anki-user.age".publicKeys = all;
  "aliases.age".publicKeys = all;
}
