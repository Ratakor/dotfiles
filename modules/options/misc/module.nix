{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str int;

  cfg = config.self;
in
{
  options.self = {
    username = mkOption {
      type = str;
      description = "Username of the main user.";
      default = "ratakor";
    };

    fontSize = mkOption {
      type = int;
      default = 10;
      description = "Font size, mainly used by terminal emulator.";
    };
  };
}
