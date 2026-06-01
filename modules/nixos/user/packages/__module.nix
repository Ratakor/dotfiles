{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatLists concatMap filter;
  inherit (lib.filesystem) listFiles;
  inherit (lib.strings) hasSuffix;
in
{
  user.packages =
    listFiles ./.
    |> filter (path: !hasSuffix "__module.nix" path) # :(
    |> concatMap (path: import path { inherit config lib pkgs; })
    |> concatLists;
}
