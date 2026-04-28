{ lib, ... }:
{
  imports =
    map lib.listFiles [
      ./cli
      ./gui
      ./misc
    ]
    |> builtins.concatLists;
}
