{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (builtins) concatMap;
  inherit (lib.options) mkOption mkEnableOptions enumOptionValues;
  inherit (lib.types) enum;
  inherit (lib.lists) optional;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    shell = mkEnableOptions opt.default.shell.name;

    default.shell = {
      name = mkOption {
        type = enum [
          "zsh"
          "nushell"
        ];
        default = "zsh";
        description = ''
          The default shell to use.
          This will automatically enable the corresponding program.
        '';
      };
    };
  };

  config = {
    self.programs.shell.${cfg.default.shell.name}.enable = true;

    # Shells must be installed system-wide or it may
    # cause issue when switching default back-and-forth.
    environment.systemPackages = concatMap (name: optional cfg.shell.${name}.enable pkgs.${name}) (
      enumOptionValues opt.default.shell.name
    );
  };
}
