{lib, ...}: word:
if word == ""
then ""
else let
  head = builtins.substring 0 1 word;
  tail = builtins.substring 1 (builtins.stringLength word - 1) word;
in "${lib.toUpper head}${tail}"
