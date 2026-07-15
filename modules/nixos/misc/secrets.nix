{
  config,
  lib,
  self,
  sources,
  ...
}:
let
  inherit (builtins) mapAttrs;
  inherit (lib.modules) mkIf mkMerge;

  module = import "${sources.agenix}/modules/age.nix";

  mkAgenixSecret =
    {
      file,
      owner ? "root",
      group ? "root",
      mode ? "0400",
    }:
    {
      file = "${toString self}/secrets/${file}";
      inherit group owner mode;
    };

  mkAgenixSecretsFor =
    username: secrets:
    mkIf (config.self.user.name == username) (
      mapAttrs (
        _name: file:
        mkAgenixSecret {
          inherit file;
          owner = username;
          group = "users"; # could be username or "root" too
        }
      ) secrets
    );
in
{
  imports = [ module ];

  age.secrets = mkMerge [
    (mkAgenixSecretsFor "ratakor" {
      irc = "irc.age";
      git-epita = "git-epita.age";
      anki-key = "anki-key.age";
      anki-user = "anki-user.age";
      aliases = "aliases.age";
    })
  ];
}
