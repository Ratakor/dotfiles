{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOption
    mkEnableOptions
    mkEnableOptions'
    literalExpression
    ;
  inherit (lib.types) nullOr enum;

  odprg = options.self.programs.default;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  options.self.programs = {
    editor =
      recursiveUpdate (mkEnableOptions odprg.editor.name // mkEnableOptions' odprg.editor.visual.name)
        {
          helix = {
            enableNoctaliaIntegration = mkEnableOption "noctalia integration" // {
              default = prg.desktopShell.noctalia.enable;
              defaultText = literalExpression ''
                config.self.programs.desktopShell.noctalia.enable
              '';
            };
          };
        };

    default.editor = {
      name = mkOption {
        type = enum [
          "helix"
          "micro"
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
    editor.${dprg.editor.name}.enable = true;
    editor.${dprg.editor.visual.name}.enable = true;
  };
}
