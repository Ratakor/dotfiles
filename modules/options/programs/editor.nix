{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str nullOr;
in
{
  options.self.programs = {
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
  };
}
