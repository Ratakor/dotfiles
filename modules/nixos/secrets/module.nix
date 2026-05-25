{
  config,
  lib,
  self,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;

  module = import "${sources.agenix}/modules/age.nix";

  mkAgenixSecret =
    {
      file,
      owner ? "root",
      group ? "root",
      mode ? "400",
    }:
    {
      file = "${toString self}/secrets/${file}";
      inherit group owner mode;
    };
in
{
  imports = [ module ];

  age.secrets = mkMerge [
    (mkIf (config.self.user.name == "ratakor") {
      irc = mkAgenixSecret {
        file = "irc.age";
        owner = "ratakor";
        group = "users";
      };
      git-epita = mkAgenixSecret {
        file = "git-epita.age";
        owner = "ratakor";
        group = "users";
      };
      anki-key = mkAgenixSecret {
        file = "anki-key.age";
        owner = "ratakor";
        group = "users";
      };
      anki-user = mkAgenixSecret {
        file = "anki-user.age";
        owner = "ratakor";
        group = "users";
      };
      aliases = mkAgenixSecret {
        file = "aliases.age";
        owner = "ratakor";
        group = "users";
      };
    })
  ];
}
