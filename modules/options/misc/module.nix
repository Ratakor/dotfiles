{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;

  cfg = config.self;
in
{
  options.self = {
    username = mkOption {
      type = str;
      description = "Username of the main user.";
      default = "ratakor";
    };
  };
}
