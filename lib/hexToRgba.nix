# hex is a string with format "RRGGBB"
# alpha is a float between 0 and 1
{lib, ...}: hex: alpha: let
  inherit (lib.trivial) fromHexString;
  inherit (builtins) substring;

  r = toString (fromHexString (substring 0 2 hex));
  g = toString (fromHexString (substring 2 2 hex));
  b = toString (fromHexString (substring 4 2 hex));
in "rgba(${r}, ${g}, ${b}, ${toString alpha})"
