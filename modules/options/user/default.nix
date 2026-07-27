{
  config,
  keys,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.strings) toSentenceCase;
  inherit (lib.types) listOf str strMatching;

  cfg = config.self.user;
in
{
  options.self.user = {
    name = mkOption {
      type = str;
      description = "Username of the main user.";
      default = "ratakor";
    };

    fullName = mkOption {
      type = str;
      description = "Full name of the main user.";
      default = toSentenceCase cfg.name;
      defaultText = literalExpression ''
        lib.strings.toSentenceCase user.name
      '';
    };

    email = mkOption {
      type = strMatching ".*@.*";
      description = "Email address of the main user.";
      default = "${cfg.name}@disroot.org";
      defaultText = literalExpression ''
        "''${user.name}@disroot.org"
      '';
    };

    keys = mkOption {
      type = listOf str;
      description = "A list of OpenSSH public keys that should be added to the user's authorized keys";
      default = keys.${cfg.name};
      defaultText = literalExpression ''
        keys.''${user.name}
      '';
    };
  };
}
