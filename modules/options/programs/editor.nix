{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOptions
    mkEnableOptions'
    ;
  inherit (lib.types) nullOr enum;

  opt = options.self.programs;
  cfg = config.self.programs;
in
{
  options.self.programs = {
    editor = mkEnableOptions opt.default.editor.name // {
      visual = mkEnableOptions' opt.default.editor.visual.name;
    };

    default.editor = {
      name = mkOption {
        type = enum [
          "helix"
          "micro"
          "neovim"
        ];
        default = "helix";
        description = ''
          The default editor to use.
          This will automatically enable the corresponding program.
        '';
      };

      package = (mkPackageOption { } "default editor" { default = null; }) // {
        internal = true;
      };

      visual = {
        name = mkOption {
          type = nullOr (enum [
            "zed"
          ]);
          default = null;
          description = ''
            The default visual editor to use.
            This will automatically enable the corresponding program.
          '';
        };

        package =
          (mkPackageOption { } "default visual editor" {
            nullable = true;
            default = null;
          })
          // {
            internal = true;
          };
      };
    };
  };

  config.self.programs = {
    editor.${cfg.default.editor.name}.enable = true;
    editor.visual.${cfg.default.editor.visual.name}.enable = true;
  };
}
