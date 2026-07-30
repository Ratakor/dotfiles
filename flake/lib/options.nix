# TODO: documentation, also this is way overkill and idk i love and hate it
{ lib, self, ... }:
let
  inherit (lib.attrsets)
    genAttrs
    getAttrFromPath
    optionalAttrs
    recursiveUpdate
    setAttrByPath
    ;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;
  inherit (lib.options)
    mkEnableOption
    mkOption
    mkPackageOption
    literalExpression
    ;
  inherit (lib.strings) optionalString toCamelCase;
  inherit (lib.trivial) id;
  inherit (lib.types) enum nullOr str;
  inherit (self.options) mkEnableOptions mkProgram mkCommandOption;
in
{
  /**
    Create multiple enable options based on the given list of values.

    Example:
      Input:
        values = [ "a" "b" "c" ]
      Output:
        {
          a.enable = mkEnableOption "a";
          b.enable = mkEnableOption "b";
          c.enable = mkEnableOption "c";
        }

    Originally included in the library as `mkEnableOptions`.
  */
  mkEnableOptions =
    values:
    genAttrs values (value: {
      enable = mkEnableOption value;
    });

  # could also add desktopShell values to values...
  mkDesktopShellProgram =
    config: name: args:
    mkProgram config name (
      args
      // {
        nullable = true;
        default = config.self.programs.default.desktopShell.name;
        defaultText = literalExpression ''
          config.self.programs.default.desktopShell.name
        '';
        redirectTo = "desktopShell";
        partOfDesktopShell = true;
      }
    );

  mkVideoProgram =
    config: name: args:
    mkProgram config name (
      args
      // {
        nullable = true;
        default = if config.self.system.video.enable then args.default else null;
        defaultText = literalExpression ''
          if config.self.system.video.enable then "${args.default}" else null
        '';
      }
    );

  mkProgram =
    config: name:
    {
      values,
      # The option path starting from `options.self.programs`
      optionPath ? [ (toCamelCase name) ], # toLower before toCamelCase?
      # Whether default.${optionPath}.name is nullable
      nullable ? false,
      # Default value for default.${optionPath}.name
      default ? null,
      # Default text for default.${optionPath}.name
      defaultText ? null,
      # Whether to include default.${optionPath}.package
      hasPackage ? false,
      # Whether to redirect to desktop shell option in description
      partOfDesktopShell ? false, # TODO: can be checked if desktop shell in value
      # Optional redirection to another option in description
      redirectTo ? null,
      # Commands provided by default program, name: description
      commands ? { },
      # Extra options to append to default.${optionPath}
      extraDefaultOptions ? { },
      # Extra options to recursively append to ${optionPath}
      extraOptions ? { },
    }:
    {
      options.self.programs =
        setAttrByPath optionPath (recursiveUpdate (mkEnableOptions values) extraOptions)
        // {
          default = setAttrByPath optionPath (
            {
              name = mkOption {
                type = (if nullable then nullOr else id) (enum values);
                inherit default defaultText;
                description = ''
                  The default ${name} to use.
                  This will automatically enable the corresponding program.
                ''
                + optionalString (redirectTo != null) ''
                  Consider setting config.self.programs.default.${redirectTo}.name instead.
                '';
              };
            }
            // optionalAttrs hasPackage {
              package =
                (mkPackageOption { } "default ${name}" {
                  inherit nullable;
                  default = null;
                })
                // {
                  internal = true;
                };
            }
            // (builtins.mapAttrs (_name: mkCommandOption) commands)
            // extraDefaultOptions # should be fine to not recursive update
          );
        };

      config =
        let
          prg = config.self.programs;
          value = (getAttrFromPath optionPath prg.default).name;
        in
        (if nullable then mkIf (value != null) else id) {
          assertions = optional partOfDesktopShell {
            assertion = prg.desktopShell ? ${value} -> prg.desktopShell.${value}.enable;
            message = "The corresponding desktop shell must be enabled for ${name}.";
          };
          self.programs = setAttrByPath (
            optionPath
            ++ [
              value
              "enable"
            ]
          ) true;
        };
    };

  /**
    Helper to create command option with a dummy default value for unsupported commands.
  */
  mkCommandOption =
    desc:
    mkOption {
      type = str;
      description = "The command to ${desc}.";
      default =
        let
          msg = "Unsupported command: ${desc}";
        in
        "echo '${msg}'; notify-send '${msg}'";
      internal = true;
      # readOnly makes it so that an option can be assigned only one time
      # except that it doesn't take mkIf into account so it sucks
      # readOnly = true;
    };
}
