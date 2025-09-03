{
  lib,
  self,
  ...
}: let
  inherit (lib.modules) mkIf;

  # based on notashelf/nyx lib
  mkAgenixSecret = enableCondition: {
    file,
    owner ? "root",
    group ? "root",
    mode ? "400",
  }:
    mkIf enableCondition {
      file = "${self}/secrets/${file}";
      inherit group owner mode;
    };
in {
  imports = ["${self.pins.agenix}/modules/age.nix"];

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
  };
}
