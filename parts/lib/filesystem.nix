{ lib, self, ... }:
let
  inherit (builtins)
    readDir
    attrNames
    attrValues
    mapAttrs
    filter
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
in
{
  /**
    Given a directory, return a list of all files within it.
    This doesn't recursively go into each directory, use listFilesRecursive instead.

    # Inputs

    `dir`
    : The path to list

    # Type

    ```
    listFiles :: Path -> [Path]
    ```
  */
  listFiles = dir: readDir dir |> attrNames |> map (file: dir + /${file});

  /**
    Given a directory, return a list of all directories within it.
    This doesn't recursively go into each directory.

    # Inputs

    `dir`
    : The path to list

    # Type

    ```
    listDirs :: Path -> [Path]
    ```
  */
  listDirs =
    dir:
    readDir dir
    |> mapAttrs (name: kind: if kind == "directory" then dir + /${name} else null)
    |> attrValues
    |> filter (x: x != null);

  /**
    Given a path, return a list of all nix files.
  */
  listNixFiles = path: listFilesRecursive path |> filter (path: hasSuffix ".nix" (toString path));

  /**
    Given a path, return a list of all nix files except the root default.nix.
  */
  listModuleFiles =
    path:
    let
      root = path + /default.nix;
    in
    listFilesRecursive path |> filter (path: hasSuffix ".nix" (toString path) && path != root);

  /**
    Size constants in bytes.
  */
  B = 1;
  KiB = 1024 * self.filesystem.B;
  MiB = 1024 * self.filesystem.KiB;
  GiB = 1024 * self.filesystem.MiB;
}
