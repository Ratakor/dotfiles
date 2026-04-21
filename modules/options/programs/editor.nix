{
  config,
  lib,
  options,
  self,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str;
  inherit (self.lib.options) mkEnableOptions';

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    editor = mkEnableOptions' opt.default.editor.name;

    default.editor = {
      name = mkOption {
        type = enum [
          "neovim"
          "helix"
        ];
        default = "helix";
        description = "The default editor to use.";
      };

      cmd = mkOption {
        type = str;
        # readOnly makes it so that an option can be assigned only one time
        # except that it doesn't take mkIf into account so it sucks
        #readOnly = true;
        description = "The command to spawn an editor in the terminal.";
      };

      desktopEntry = mkOption {
        type = str;
        description = "The desktop entry of the editor.";
      };
    };
  };

  config.self.programs = {
    editor.${cfg.default.editor.name}.enable = true;
  };
}
