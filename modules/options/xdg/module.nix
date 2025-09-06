{lib, ...}: let
  inherit (lib.types) str;
  inherit (lib.options) mkOption;
in {
  options.xdg = {
    config = mkOption {
      type = str;
      default = ".config";
      description = "The XDG config home directory.";
    };

    data = mkOption {
      type = str;
      default = ".local/share";
      description = "The XDG data home directory.";
    };

    cache = mkOption {
      type = str;
      default = ".cache";
      description = "The XDG cache home directory.";
    };

    state = mkOption {
      type = str;
      default = ".local/state";
      description = "The XDG state home directory.";
    };
  };
}
