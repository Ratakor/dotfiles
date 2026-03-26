{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types)
    enum
    str
    int
    nullOr
    ;

  cfg = config.self;
in
{
  options.self = {
    editor = {
      program = mkOption {
        type = enum [
          "neovim"
          "helix"
        ];
        default = "helix";
        description = "The editor to use.";
      };

      cmd = mkOption {
        type = nullOr str;
        default = null;
        description = "The command to spawn an editor in the terminal.";
      };

      desktopEntry = mkOption {
        type = nullOr str;
        default = null;
        description = "The desktop entry of the editor.";
      };
    };

    font-size = mkOption {
      type = int;
      default = 10;
      description = "Font size, mainly for terminal.";
    };
  };
}
