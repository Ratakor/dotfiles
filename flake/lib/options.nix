{ lib, self, ... }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;
  inherit (self.attrsets) genAttrs;
  inherit (self.options) enumOptionValues enumOptionValues';
  inherit (self.types) enumValues unwrapNullOr;

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
  mkEnableOptionsImplem =
    values:
    genAttrs values (value: {
      enable = mkEnableOption value;
    });
in
{
  /**
    Returns the values of an option which type is an enum.
  */
  enumOptionValues = option: enumValues option.type;

  /**
    Returns the values of an option which type is a nullOr enum.
    `null` is not included.
  */
  enumOptionValues' = option: enumValues (unwrapNullOr option.type);

  /**
    Creates multiple enable options based on the given enum option.
  */
  mkEnableOptions = option: mkEnableOptionsImplem (enumOptionValues option);

  /**
    Creates multiple enable options based on the given nullOr enum option.
  */
  mkEnableOptions' = option: mkEnableOptionsImplem (enumOptionValues' option);

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
