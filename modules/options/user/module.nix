{ config, lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str strMatching;
  inherit (lib.trivial) capitalize;

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
      default = capitalize cfg.name;
    };

    email = mkOption {
      type = strMatching ".*@.*";
      description = "Email address of the main user.";
      default = "${cfg.name}@disroot.org";
    };
  };
}
