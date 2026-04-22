{
  lib,
  self,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  module = import "${sources.agenix}/modules/age.nix";

  # based on notashelf/nyx lib
  mkAgenixSecret =
    enableCondition:
    {
      file,
      owner ? "root",
      group ? "root",
      mode ? "400",
    }:
    mkIf enableCondition {
      file = "${self}/secrets/${file}";
      inherit group owner mode;
    };
in
{
  imports = [ module ];

  age.secrets = {
    irc = mkAgenixSecret true {
      file = "irc.age";
      owner = "ratakor";
      group = "users";
    };
    git-epita = mkAgenixSecret true {
      file = "git-epita.age";
      owner = "ratakor";
      group = "users";
    };
    anki-key = mkAgenixSecret true {
      file = "anki-key.age";
      owner = "ratakor";
      group = "users";
    };
    anki-user = mkAgenixSecret true {
      file = "anki-user.age";
      owner = "ratakor";
      group = "users";
    };
    aliases = mkAgenixSecret true {
      file = "aliases.age";
      owner = "ratakor";
      group = "users";
    };
  };
}
