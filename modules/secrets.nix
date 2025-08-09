{
  inputs,
  lib,
  ...
}: let
  # based on notashelf/nyx lib
  mkAgenixSecret = enableCondition: {
    file,
    owner ? "root",
    group ? "root",
    mode ? "400",
  }:
    lib.mkIf enableCondition {
      file = "${inputs.self}/secrets/${file}";
      inherit group owner mode;
    };
in {
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
