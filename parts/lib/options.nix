{ lib, self, ... }:
let
  inherit (builtins) listToAttrs;
  inherit (lib.options) mkEnableOption;
  inherit (self.types) enumValues;
  inherit (self.options) enumOptionValues mkEnableOptions;
in
{
  /**
    Return the values of an option which type is an enum.
  */
  enumOptionValues = option: enumValues option.type;

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
  */
  mkEnableOptions =
    values:
    values
    |> map (value: {
      name = value;
      value.enable = mkEnableOption value;
    })
    |> listToAttrs;

  /**
    Create multiple enable options based on the given enum option.
  */
  mkEnableOptions' = option: mkEnableOptions (enumOptionValues option);
}
