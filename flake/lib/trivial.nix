{ lib, ... }:
let
  inherit (builtins)
    substring
    stringLength
    hasAttr
    getAttr
    ;
  inherit (lib.trivial) fromHexString;
  inherit (lib.strings) toUpper;
in
{
  /**
    Capitalize the first letter of a word.
    If the word is empty, it returns an empty string.
  */
  capitalize =
    word:
    if word == "" then
      ""
    else
      let
        head = substring 0 1 word;
        tail = substring 1 (stringLength word - 1) word;
      in
      "${toUpper head}${tail}";

  /**
    Convert a hex color string to an rgba string.

    # Inputs

    `hex`
    : String in the format "RRGGBB"

    `alpha`
    : Float between 0 and 1

    # Type

    ```
    hexToRgba :: String -> Float -> String
    ```
  */
  hexToRgba =
    hex: alpha:
    let
      r = toString (fromHexString (substring 0 2 hex));
      g = toString (fromHexString (substring 2 2 hex));
      b = toString (fromHexString (substring 4 2 hex));
    in
    "rgba(${r}, ${g}, ${b}, ${toString alpha})";

  # check if the host platform is linux and x86
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;

  # Abort with an error message if this code is ever executed.
  unreachable = abort "Reached unreachable code!";

  /**
    Returns the attribute named s from set or fallback if it doesn't exist.

    # Inputs

    `s`
    : String

    `set`
    : AttrSet

    `fallback`
    : a

    # Type

    ```
    getAttrOr :: String -> AttrSet -> a -> a
    ```
  */
  getAttrOr =
    s: set: fallback:
    if hasAttr s set then getAttr s set else fallback;

  /**
    Returns the corresponding shortRev for the given revision.
  */
  shortRev = rev: substring 0 7 rev;
}
