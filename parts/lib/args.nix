{lib, ...}: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) escapeShellArg;
in {
  /**
  Convert an attribute set of arguments to a list of shell arguments.
  - Boolean false and null values are omitted.
  - Boolean true values are converted to flags (e.g. `--flag`).
  - Other values are converted to `--key=value`, with proper shell escaping.

  # Inputs

  `args`
  : An attribute set where keys are argument names and values are argument values.

  # Type

  ```
  mapShellArgsToList :: AttrSet -> [String]
  ```
  */
  mapShellArgsToList = args:
    mapAttrsToList (
      k: v:
        if v == null || v == false
        then ""
        else if v == true
        then "--${k}"
        else escapeShellArg "--${k}=${toString v}"
    )
    args;
}
