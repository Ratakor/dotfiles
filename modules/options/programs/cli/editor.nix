{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkPackageOption mkEnableOptions;
  inherit (lib.types) enum str;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    editor = mkEnableOptions opt.default.editor.name;

    default.editor = {
      name = mkOption {
        type = enum [
          "helix"
          "neovim"
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

      package = mkPackageOption { } "default editor" { default = null; };
    };
  };

  config.self.programs = {
    editor.${cfg.default.editor.name}.enable = true;
  };
}
