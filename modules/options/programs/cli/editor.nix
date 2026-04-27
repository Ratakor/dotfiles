{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options) mkOption mkPackageOption mkEnableOptions;
  inherit (lib.types) enum;

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

      package = mkPackageOption { } "default editor" { default = null; };
    };
  };

  config.self.programs = {
    editor.${cfg.default.editor.name}.enable = true;
  };
}
