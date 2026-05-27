{ lib, self, ... }:
let
  inherit (builtins)
    attrNames
    filter
    pathExists
    readDir
    ;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten singleton;
  inherit (lib.strings) hasSuffix;
  inherit (self.filesystem) filterNixFiles;
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
  listFiles = dir: readDir dir |> attrNames |> map (file: dir + "/${file}");

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
    |> mapAttrsToList (name: kind: if kind == "directory" then dir + "/${name}" else null)
    |> filter (x: x != null);

  /**
    Given a list of files, return a list of all nix files.
  */
  filterNixFiles = files: filter (path: hasSuffix ".nix" (toString path)) files;

  /**
    Given a path, returns a module tree.
  */
  listModuleFiles =
    dir:
    let
      internalFunc =
        dir:
        mapAttrsToList (
          name: type:
          let
            path = dir + "/${name}";
            module = path + "/__module.nix";
          in
          if type == "directory" then (if pathExists module then module else internalFunc path) else path
        ) (readDir dir);

      root = dir + "/__module.nix";
    in
    if pathExists root then singleton root else (dir |> internalFunc |> flatten |> filterNixFiles);

  /**
    Size constants in bytes.
  */
  B = 1;
  KiB = 1024 * self.filesystem.B;
  MiB = 1024 * self.filesystem.KiB;
  GiB = 1024 * self.filesystem.MiB;
}
