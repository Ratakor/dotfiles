{ lib, ... }:
{
  # btw the only reason we still have a default.nix for each modules is
  # because of colors... also home but that's something else.
  # One solution could be to outsource colors.
  imports =
    map lib.listFilesRecursive [
      ./device
      ./misc
      ./programs
      ./services
      ./system
      ./user
    ]
    |> builtins.concatLists
    |> lib.concat [ ./colors/option.nix ];
}
