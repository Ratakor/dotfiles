# A calendar CLI like `when`
# TODO: Rewrite quand in rust & integrate icstocal
{ lib, pkgs, ... }:
let
  inherit (builtins)
    isInt
    isString
    typeOf
    readFile
    ;

  icstocal = pkgs.writeScriptBin "icstocal" (readFile ./icstocal.py);

  mkValueString =
    v:
    if isInt v then
      toString v
    else if isString v then
      "\"${v}\""
    else if true == v then
      "1"
    else if false == v then
      "0"
    else
      throw "Unsupported value type: ${typeOf v}";

  toKeyValue = lib.generators.toKeyValue {
    mkKeyValue = k: v: "${k}=${mkValueString v}";
  };
in
{
  user.packages = [
    pkgs.quand
    icstocal
  ];

  hm.xdg.configFile."quand/config".text = toKeyValue {
    header = false;
    mondayfirst = true;
    past = 0;
    future = 1;
    yesterday = "\\033[36myesterday  ";
    today = "\\033[35;1mtoday      ";
    tomorrow = "\\033[32mtomorrow   ";
    special = "\\033[33;3m*special* ";
  };
}
