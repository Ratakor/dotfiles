{ lib, self, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (self.types) enumValues unwrapNullOr;
  inherit (self.options) enumOptionValues enumOptionValues';
  inherit (self.attrsets) genAttrs;

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
    Return the values of an option which type is an enum.
  */
  enumOptionValues = option: enumValues option.type;

  /**
    Return the values of an option which type is a nullOr enum.
    `null` is not included.
  */
  enumOptionValues' = option: enumValues (unwrapNullOr option.type);

  /**
    Create multiple enable options based on the given enum option.
  */
  mkEnableOptions = option: mkEnableOptionsImplem (enumOptionValues option);

  /**
    Create multiple enable options based on the given nullOr enum option.
  */
  mkEnableOptions' = option: mkEnableOptionsImplem (enumOptionValues' option);
}
