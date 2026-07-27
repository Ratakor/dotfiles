{ lib, ... }:
let
  inherit (builtins) substring;
  inherit (lib.trivial) fromHexString;
in
{
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
}
