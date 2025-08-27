{lib, ...}: {
  /**
  Capitalize the first letter of a word.
  If the word is empty, it returns an empty string.
  */
  capitalize = word:
    if word == ""
    then ""
    else let
      head = builtins.substring 0 1 word;
      tail = builtins.substring 1 (builtins.stringLength word - 1) word;
    in "${lib.toUpper head}${tail}";

  /**
  Convert a hex color string to an rgba string.

  # Inputs

  `hex`
  : a string in the format "RRGGBB"

  `alpha`
  : a float between 0 and 1

  # Type

  ```
  hexToRgba :: String -> Float -> String
  ```
  */
  hexToRgba = hex: alpha: let
    inherit (lib.trivial) fromHexString;
    inherit (builtins) substring;

    r = toString (fromHexString (substring 0 2 hex));
    g = toString (fromHexString (substring 2 2 hex));
    b = toString (fromHexString (substring 4 2 hex));
  in "rgba(${r}, ${g}, ${b}, ${toString alpha})";
}
